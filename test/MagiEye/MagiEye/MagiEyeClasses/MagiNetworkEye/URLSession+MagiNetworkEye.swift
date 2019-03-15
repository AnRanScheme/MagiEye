//
//  URLSession+MagiNetworkEye.swift
//  MagiNetworkEye
//
//  Created by anran on 2019/3/12.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation


extension URLSession {
    
    private struct key {
        static var isSwizzled: Character = "c"
    }
    
    private static var isSwizzled: Bool {
        set{
            objc_setAssociatedObject(
                self,
                &key.isSwizzled,
                isSwizzled,
                .OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            guard let result = objc_getAssociatedObject(
                self,
                &key.isSwizzled)
                as? Bool
                else {
                   return false
            }
            return result
        }
    }
    
    @objc
    convenience init(configurationMonitor: URLSessionConfiguration, delegate: URLSessionDelegate?, delegateQueue queue: OperationQueue?) {
        
        if configurationMonitor.protocolClasses != nil {
            configurationMonitor.protocolClasses!.insert(MagiEyeURLProtocol.classForCoder(), at: 0)
        }else {
            configurationMonitor.protocolClasses = [MagiEyeURLProtocol.classForCoder()]
        }
        
        self.init(configurationMonitor: configurationMonitor, delegate: delegate, delegateQueue: queue)
    }
    
    class func open() {
        if self.isSwizzled == false && self.hook() == .succeed {
            self.isSwizzled = true
        }else {
            print("[MagiNetworkEye] already started or hook failure")
        }
    }
    
    class func close() {
        if self.isSwizzled == true && self.hook() == .succeed {
            self.isSwizzled = false
        }else {
            print("[MagiNetworkEye] already stoped or hook failure")
        }
    }
    
    
    private class func hook() -> SwizzleResult {
        // let orig = #selector(URLSession.init(configuration:delegate:delegateQueue:))
        // the result is sessionWithConfiguration:delegate:delegateQueue: which runtime can't find it
        
        let orig = #selector(URLSession.init(configuration:delegate:delegateQueue:))
        let alter = #selector(URLSession.init(configurationMonitor:delegate:delegateQueue:))
        let result = URLSession.swizzleInstanceMethod(origSelector: orig, toAlterSelector: alter)
        return result
    }

}
