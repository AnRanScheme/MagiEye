//
//  DispatchQueue+MagiLeakEye.swift
//  MagiLeakEye
//
//  Created by anran on 2019/3/14.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    
    fileprivate static var _onceTracker = [String]()
    
    class func once(_ file: String = #file,
                           function: String = #function,
                           line: Int = #line,
                           block:()->Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(token: String, block:()->Void) {
        // 原子操作 对于一个资源，在写入或读取时，只允许在一个时刻一个角色进行操作，则为原子操作。
        // objc_sync_enter objc_sync_exit配合使用
        objc_sync_enter(self)
        // defer作用延后之行,但是一定会在 return 之前之行
        defer { objc_sync_exit(self) }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
