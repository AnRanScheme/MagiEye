//
//  String+MagiLeakEye.swift
//  MagiLeakEye
//
//  Created by anran on 2019/3/14.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

extension String {
    
    ///  Finds the string between two bookend strings if it can be found.
    ///
    ///  - parameter left:  The left bookend
    ///  - parameter right: The right bookend
    ///
    ///  - returns: The string between the two bookends, or nil if the bookends cannot be found, the bookends are the same or appear contiguously.
    public func between(left: String, right: String) -> String? {

        guard
            let leftRange = range(of:left),
            let rightRange = self.range(of: right,
                                        options: String.CompareOptions.backwards,
                                        range: nil,
                                        locale: nil),
            left != right && leftRange.upperBound != rightRange.lowerBound
            else { return nil }
        
        
        return String(self[leftRange.upperBound..<rightRange.lowerBound])
        
    }
}
