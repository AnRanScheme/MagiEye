//
//  MagiCrashModel.swift
//  MagiCrash
//
//  Created by anran on 2019/3/11.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation


// MARK: - CrashModelType
public enum MagiCrashModelType: Int {
    case signal = 1
    case exception = 2
}

// MARK: - CrashModel
open class MagiCrashModel: NSObject {
    
    open var type: MagiCrashModelType!
    open var name: String!
    open var reason: String!
    open var appinfo: String!
    open var callStack: String!
    
    init(type: MagiCrashModelType,
         name: String,
         reason: String,
         appinfo: String,
         callStack: String) {
        super.init()
        self.type = type
        self.name = name
        self.reason = reason
        self.appinfo = appinfo
        self.callStack = callStack
    }
    
}
