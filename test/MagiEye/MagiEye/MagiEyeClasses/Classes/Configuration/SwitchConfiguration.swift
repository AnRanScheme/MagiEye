//
//  SwitchConfiguration.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

/// DESCRIPTION: all switch is default switch value, it only will
/// work while passed as argument while GodEye init.
/// In an other words,after the GodEye has inited,you can't
/// change the switch value to turn on or turn off the monitor eye
open class SwitchConfiguration: NSObject {
    /// asl switch defualt value
    open var asl: Bool = false
    /// magiLog switch default value
    open var log: Bool = true
    /// crash switch default value
    open var crash: Bool = true
    /// network switch default value
    open var network: Bool = true
    /// caton switch default value
    open var caton: Bool = true
    /// leak switch default value
    open var leak: Bool = true
}
