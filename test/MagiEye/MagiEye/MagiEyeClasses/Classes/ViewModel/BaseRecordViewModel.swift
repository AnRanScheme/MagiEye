//
//  BaseRecordViewModel.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation
import UIKit

class BaseRecordViewModel: NSObject {
    
    private(set) var attributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                   NSAttributedString.Key.font: UIFont.courier(with: 12)]
    
    func contentString(with prefex: String?, content: String?, newline: Bool = false, color: UIColor = UIColor(hex: 0x3D82C7)) -> NSAttributedString {
        let pre = prefex != nil ? "[\(prefex!)]:" : ""
        let line = newline == true ? "\n" : (pre == "" ? "" : " ")
        let str = "\(pre)\(line)\(content ?? "nil")\n"
        let result = NSMutableAttributedString(string: str, attributes: self.attributes)
        let range = str.NS.range(of: pre)
        if range.location != NSNotFound {
            result.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        return result
    }
    
    func headerString(with prefex:String,content:String? = nil,color:UIColor) -> NSAttributedString {
        let header = "> \(prefex): \(content ?? "")\n"
        let result = NSMutableAttributedString(string: header, attributes: self.attributes)
        
        let range = header.NS.range(of: prefex)
        if range.location + range.length <= header.NS.length {
            result.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
        }
        return result
    }
}
