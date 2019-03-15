//
//  CommandRecordModel.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

final class CommandRecordModel: NSObject {
    private(set) var command: String
    private(set) var actionResult: String
    
    init(command: String, actionResult: String) {
        self.command = command
        self.actionResult = actionResult
        super.init()
    }
}
