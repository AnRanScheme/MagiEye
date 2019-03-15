//
//  MagiNetworkEye.swift
//  MagiNetworkEye
//
//  Created by anran on 2019/3/12.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

@objc
public protocol MagiNetworkEyeDelegate: NSObjectProtocol {
    func networkEyeDidCatch(with request: URLRequest?, response: URLResponse?,data: Data?)
}

open class MagiNetworkEye: NSObject {
    
    public static var isWatching: Bool  {
        get {
            return MagiEyeURLProtocol.delegates.count > 0
        }
    }
    
    open class func add(observer: MagiNetworkEyeDelegate) {
        if MagiEyeURLProtocol.delegates.count == 0 {
            MagiEyeURLProtocol.open()
            URLSession.open()
        }
        MagiEyeURLProtocol.add(delegate: observer)
    }
    
    open class func remove(observer: MagiNetworkEyeDelegate) {
        MagiEyeURLProtocol.remove(delegate: observer)
        if MagiEyeURLProtocol.delegates.count == 0 {
            MagiEyeURLProtocol.close()
            URLSession.close()
        }
    }
    
}
