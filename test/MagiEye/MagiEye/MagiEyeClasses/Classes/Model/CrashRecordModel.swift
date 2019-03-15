//
//  CrashRecordModel.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

final class CrashRecordModel: NSObject {
    var type: MagiCrashModelType
    var name: String
    var reason: String
    var appinfo: String
    var callStack: String
    
    init(model: MagiCrashModel) {
        self.type = model.type
        self.name = model.name
        self.reason = model.reason
        self.appinfo = model.appinfo
        self.callStack = model.callStack
        super.init()
    }
    
    init(type: MagiCrashModelType, name: String, reason: String, appinfo: String, callStack: String) {
        self.type = type
        self.name = name
        self.reason = reason
        self.appinfo = appinfo
        self.callStack = callStack
        super.init()
    }
    
}
