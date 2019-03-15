//
//  Configuration.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

// MARK: - Configuration
/// DESCRIPTION: Configuration form use setting or default
open class Configuration: NSObject {
    /// control configuration
    open private(set) var control = ControlConfiguration()
    /// command configuration
    open private(set) var command = CommandConfiguration()
    /// default switch configuration
    open private(set) var defaultSwitch = SwitchConfiguration()
}
