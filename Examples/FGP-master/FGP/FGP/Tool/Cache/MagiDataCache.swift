//
//  MagiDataCache.swift
//  
//
//  Created by 安然 on 2018/7/26.
//  Copyright © 2018年 dudongge. All rights reserved.
// 接入桥文件
// #import <CommonCrypto/CommonCrypto.h>
import UIKit

let MagiCacheKeyPath = "MagiCacheKeyPath"

open class MagiDataCache {

    fileprivate class func jsonToData(_ jsonResponse: AnyObject) -> Data? {
        do {
            let data = try JSONSerialization.data(
                withJSONObject: jsonResponse,
                options: JSONSerialization.WritingOptions.prettyPrinted)
            
            return data
        }
            
        catch {
            
            return nil
        }
    }
    
    fileprivate class func dataToJson(_ data: Data) -> AnyObject? {
        do {
            let json = try JSONSerialization.jsonObject(
                with: data,
                options: JSONSerialization.ReadingOptions.mutableContainers)
            
            return json as AnyObject?
        }
        catch {
            
            return nil
        }
    }
    
    fileprivate class func cacheFilePathWithURL(_ URL: String,
                                                path: String ,
                                                subPath:String = "") -> String {
        var newPath: String = ""
        if subPath.count == 0 {
            //保存最新的一级目录
            UserDefaults.standard.set(path, forKey: MagiCacheKeyPath)
            UserDefaults.standard.synchronize()
            newPath = cachePath()
        }
        else {
            newPath = cacheSubPath(subPath)
        }
        checkDirectory(newPath)
        //check路径
        let cacheFileNameString: String = "URL:\(URL) AppVersion:\(appVersionString())"
        let cacheFileName: String = md5StringFromString(cacheFileNameString)
        newPath = newPath + "/" + cacheFileName
        return newPath
    }
    
    fileprivate class func checkDirectory(_ path: String) {
        let fileManager: FileManager = FileManager.default
        var isDir = ObjCBool(false) //isDir判断是否为文件夹
        fileManager.fileExists(atPath: path, isDirectory: &isDir)
        if !fileManager.fileExists(atPath: path, isDirectory: &isDir) {
            
            createBaseDirectoryAtPath(path)
        }
        else {
            if !isDir.boolValue {
                do {
                    try fileManager.removeItem(atPath: path)
                    
                    createBaseDirectoryAtPath(path)
                }
                catch let error as NSError {
                    
                    print("create cache directory failed, error = %@", error)
                }
            }
        }
    }
    
    fileprivate class func createBaseDirectoryAtPath(_ path: String) {
        do {
            try FileManager.default.createDirectory(
                atPath: path,
                withIntermediateDirectories: true, attributes: nil)
            print("path ="+path)
            
            addDoNotBackupAttribute(path)
        }
        catch let error as NSError {
            
            print("create cache directory failed, error = %@", error)
        }
    }
    
    fileprivate class func addDoNotBackupAttribute(_ path: String) {
        let url: URL = URL(fileURLWithPath: path)
        do {
            try (url as NSURL).setResourceValue(
                NSNumber(value: true as Bool),
                forKey: URLResourceKey.isExcludedFromBackupKey)
        }
        catch let error as NSError {
            
            print("error to set do not backup attribute, error = %@", error)
        }
    }
    
    fileprivate class func md5StringFromString(_ string: String) -> String {
        let str = string.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen);
        CC_MD5(str!, strLen, result);
        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        
        return String(format: hash as String)
    }
    
    fileprivate class func appVersionString() -> String {
        
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
}

extension MagiDataCache {
    
    /// 写入/更新缓存(同步) [按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
    ///
    /// - Parameters:
    ///   - data: 要写入的数据
    ///   - URL: 数据请求URL
    ///   - path: 一级文件夹路径path（必须设置）
    ///   - subPath: 二级文件夹路径subPath（可设置-可不设置）
    /// - Returns: 是否写入成功
    public class func saveDataToCacheFile(_ data: Data,
                                          URL: String,
                                          path: String,
                                          subPath: String = "") -> Bool {
        let atPath =  cacheFilePathWithURL(URL,
                                           path: path,
                                           subPath: subPath)
        
        return FileManager.default.createFile(atPath: atPath,
                                              contents: data,
                                              attributes: nil)
    }
    
    /// 写入/更新缓存(异步) [按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
    ///
    /// - Parameters:
    ///   - data: 要写入的数据
    ///   - URL: 数据请求URL
    ///   - path: 一级文件夹路径path（必须设置）
    ///   - subPath: 二级文件夹路径subPath（可设置-可不设置）
    /// - Returns: 是否写入成功
    public class func save_asyncDataToCacheFile(_ data: Data,
                                                        URL: String,
                                                        path: String ,
                                                        subPath: String = "",
                                                        completed:@escaping (Bool) -> ()) {
        DispatchQueue.global().async{
            let result = saveDataToCacheFile(data,
                                             URL: URL,
                                             path: path,
                                             subPath: subPath)
            DispatchQueue.main.async(execute: {
                completed(result)
            })
        }
    }
    
    /// 获取缓存的对象(同步)
    ///
    /// - Parameters:
    ///   - URL: 数据请求URL
    ///   - subPath: 二级文件夹路径subPath（可设置-可不设置）
    /// - Returns: 缓存对象
    public class func cacheDataWithURL(_ URL: String, subPath: String = "") -> Data? {
        if let keyPath = UserDefaults.standard.string(forKey: MagiCacheKeyPath) {
            let path: String = cacheFilePathWithURL(URL,
                                                    path: keyPath,
                                                    subPath: subPath)
            let fileManager: FileManager = FileManager.default
            if fileManager.fileExists(atPath: path, isDirectory: nil) == true {
                let data: Data = fileManager.contents(atPath: path)!
                
                return data
            }
        }
        
        return nil
    }
    
    /**
     写入/更新缓存(同步) [按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
     - parameter jsonResponse: 要写入的数据(JSON)
     - parameter URL:          数据请求URL
     - parameter path:         一级文件夹路径path（必须设置）
     - parameter subPath:      二级文件夹路径subPath（可设置-可不设置）
     - returns: 是否写入成功
     */
    public class func saveJsonResponseToCacheFile(_ jsonResponse: AnyObject,
                                                  URL: String,
                                                  path: String,
                                                  subPath: String = "") -> Bool {
        let data = jsonToData(jsonResponse)
        let atPath =  cacheFilePathWithURL(URL,
                                           path: path,
                                           subPath: subPath)
        
        return FileManager.default.createFile(atPath:atPath,
                                              contents: data,
                                              attributes: nil)
    }

    /// 写入/更新缓存(异步) [按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
    ///
    /// - Parameters:
    ///   - jsonResponse: 要写入的数据(JSON)
    ///   - URL: 数据请求URL
    ///   - path: 一级文件夹路径path（必须设置）
    ///   - subPath: 二级文件夹路径subPath（可设置-可不设置）
    ///   - completed: 异步完成回调(主线程回调)
    public class func save_asyncJsonResponseToCacheFile(_ jsonResponse: AnyObject,
                                                        URL: String,
                                                        path: String ,
                                                        subPath: String = "",
                                                        completed:@escaping (Bool) -> ()) {
        
        DispatchQueue.global().async{
            let result = saveJsonResponseToCacheFile(jsonResponse,
                                                     URL: URL,
                                                     path: path,
                                                     subPath: subPath)
            DispatchQueue.main.async(execute: {
                completed(result)
            })
        }
    }

    /// 获取缓存的对象(同步)
    ///
    /// - Parameters:
    ///   - URL: 数据请求URL
    ///   - subPath: 二级文件夹路径subPath（可设置-可不设置）
    /// - Returns: 缓存对象
    public class func cacheJsonWithURL(_ URL: String, subPath: String = "") -> AnyObject? {
        if let keyPath = UserDefaults.standard.string(forKey: MagiCacheKeyPath) {
            let path: String = cacheFilePathWithURL(URL, path: keyPath,subPath: subPath)
            let fileManager: FileManager = FileManager.default
            if fileManager.fileExists(atPath: path, isDirectory: nil) == true {
                let data: Data = fileManager.contents(atPath: path)!
                
                return dataToJson(data)
            }
        }
        
        return nil
    }

    /// 获取总缓存路径
    ///
    /// - Returns: 缓存路径
    public class func cachePath() -> String {
        if let keyPath = UserDefaults.standard.string(forKey: MagiCacheKeyPath) {
            let pathOfLibrary = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.libraryDirectory,
                FileManager.SearchPathDomainMask.userDomainMask,
                true)[0] as NSString
            let path = pathOfLibrary.appendingPathComponent(keyPath)
            
            return path
        }
        
        else {
            
            return ""
        }
    }

    /// 获取子缓存路径
    ///
    /// - Parameter subPath: 子缓存路径
    /// - Returns: 完整子缓存路径
    public class func cacheSubPath(_ subPath: String = "") -> String {
        let path = cachePath() + "/" + subPath
        
        return path
    }

    /// 清除全部缓存
    ///
    /// - Returns: 清除全部缓存是否成功
    public class func clearAllCache() -> Bool{
        let fileManager: FileManager = FileManager.default
        let path: String = cachePath()
        if path.count == 0 {
            
            return false
        }
        do {
            try fileManager.removeItem(atPath: path)
            checkDirectory(cachePath())
            
            return true
        }
        catch let error as NSError {
            print("clearCache failed , error = \(error)")
            
            return false
        }
    }

    /// 清除指定文件夹下全部缓存
    ///
    /// - Parameter url: 数据请求URL
    /// - Returns: 清除指定文件夹下全部缓存是否成功
    public class func clearCacheWithUrl(_ url: String) -> Bool{
        let fileManager: FileManager = FileManager.default
        let path: String = cacheSubPath(url)
        do {
            try fileManager.removeItem(atPath: path)
            checkDirectory(cacheSubPath(url))
            
            return true
        }
        catch let error as NSError {
            print("clearCache failed , error = \(error)")
            
            return false
        }
    }

    ///  获取缓存大小
    ///
    /// - Returns: 缓存大小(单位:M)
    public class func cacheAllSize()-> Float {
        let cachePath = self.cachePath()
        do {
            let fileArr = try FileManager.default.contentsOfDirectory(atPath: cachePath)
            var size:Float = 0
            for file in fileArr{
                let path = cachePath + "/\(file)"
                let floder = try! FileManager.default.attributesOfItem(atPath: path)
                for (abc, bcd) in floder {
                    if abc == FileAttributeKey.size {
                        size += (bcd as AnyObject).floatValue
                    }
                }
            }
            let total = size / 1024.0 / 1024.0
            
            return total
        }
        catch {
            
            return 0
        }
    }

    /// 获取单个文件夹下缓存大小
    ///
    /// - Parameter Url: 数据请求URL
    /// - Returns: 子缓存大小(单位:M)
    public class func cacheSizeWithUrl(_ Url: String)-> Float {
        let cachePath = cacheSubPath(Url)
        do {
            let fileArr = try FileManager.default.contentsOfDirectory(atPath: cachePath)
            var size:Float = 0
            for file in fileArr{
                let path = cachePath + "/\(file)"
                let floder = try! FileManager.default.attributesOfItem(atPath: path)
                for (abc, bcd) in floder {
                    if abc == FileAttributeKey.size {
                        size += (bcd as AnyObject).floatValue
                    }
                }
            }
            let total = size / 1024.0 / 1024.0
            
            return total
        }
        catch {
            
            return 0
        }
    }
    
}


