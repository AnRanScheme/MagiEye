//
//  MagiEye.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

open class MagiEye: NSObject {
    
    open class func makeEye(with window: UIWindow, configuration: Configuration = Configuration()) {
        LogRecordModel.create()
        CrashRecordModel.create()
        NetworkRecordModel.create()
        CatonRecordModel.create()
        CommandRecordModel.create()
        LeakRecordModel.create()
        
        window.makeEye(with: configuration)
    }
}
