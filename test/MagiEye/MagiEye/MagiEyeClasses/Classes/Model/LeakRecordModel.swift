//
//  LeakRecordModel.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

final class LeakRecordModel: NSObject {
    
    private(set) var clazz: String
    private(set) var address: String
    
    init(obj: NSObject) {
        self.clazz = NSStringFromClass(obj.classForCoder)
        self.address = String(format:"%p", obj)
    }
    
    init(clazz: String, address: String) {
        self.clazz = clazz
        self.address = address
        super.init()
    }
    
}
