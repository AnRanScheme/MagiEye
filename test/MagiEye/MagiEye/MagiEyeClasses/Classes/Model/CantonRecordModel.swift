//
//  CantonRecordModel.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

final class CatonRecordModel: NSObject {
    
    private(set) var threshold: Double
    private(set) var mainThreadBacktrace: String?
    private(set) var allThreadBacktrace: String?
    
    init(threshold: Double, mainThreadBacktrace: String?, allThreadBacktrace: String?) {
        self.threshold = threshold
        self.mainThreadBacktrace = mainThreadBacktrace
        self.allThreadBacktrace = allThreadBacktrace
        super.init()
        self.showAll = false
    }
}
