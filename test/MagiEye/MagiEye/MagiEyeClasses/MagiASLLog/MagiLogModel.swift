//
//  MagiLogModel.swift
//  MagiASLLog
//
//  Created by anran on 2019/3/7.
//  Copyright © 2019 anran. All rights reserved.
//

public enum MagiLogType: Int {
    case info = 1
    case warning = 2
    case error = 3
}

import UIKit

open class MagiLogModel: NSObject {
    
    open private(set) var type: MagiLogType
    /// date for Time stamp
    open private(set) var date: Date
    /// thread which log the message
    open private(set) var thread: Thread
    /// filename with extension
    open private(set) var file: String
    /// number of line in source code file
    open private(set) var line: Int
    /// name of the function which log the message
    open private(set) var function: String
    /// message be logged
    open private(set) var message: String
    
    init(type: MagiLogType,
         thread: Thread,
         message: String,
         file: String,
         line: Int,
         function: String) {
        self.date = Date()
        self.type = type
        self.thread = thread
        self.file = file
        self.line = line
        self.function = function
        self.message = message
        super.init()
    }
    
}
