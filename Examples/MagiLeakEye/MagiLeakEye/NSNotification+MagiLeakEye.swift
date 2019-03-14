//
//  NSNotification+MagiLeakEye.swift
//  MagiLeakEye
//
//  Created by anran on 2019/3/14.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let scan = NSNotification.Name("MagiLeakEyeScan") 
    
    static let receive = NSNotification.Name("MagiLeakEyeReceive")
}
