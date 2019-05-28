//
//  CatonRecordViewModel.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

class CatonRecordViewModel: BaseRecordViewModel {
    
    private(set) var model: CatonRecordModel
    
    init(_ model: CatonRecordModel) {
        self.model = model
        super.init()
    }
    
    func attributeString() -> NSAttributedString {
        
        let result = NSMutableAttributedString()
        result.append(self.headerString())
        result.append(self.mainThreadBacktraceString())
        
        if self.model.showAll {
            result.append(self.allThreadBacktraceString())
        }else {
            result.append(self.contentString(with: "Click cell to show all",
                                             content: "...",
                                             newline: false,
                                             color: UIColor.cyan))
        }
        
        return result
    }
    
    private func headerString() -> NSAttributedString {
        let content = "main thread not response with threshold:\(String(describing: self.model.threshold))"
        return self.headerString(with: "Caton", content: content, color: UIColor(hex: 0xFF0000))
    }
    
    private func mainThreadBacktraceString() -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self.contentString(with: "MainThread Backtrace", content: self.model.mainThreadBacktrace, newline: true))
        let  range = result.string.NS.range(of: self.model.mainThreadBacktrace!)
        if range.location != NSNotFound {
            let att: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Courier", size: 6)!,
                                                      NSAttributedString.Key.foregroundColor: UIColor.white]
            result.setAttributes(att, range: range)
            
        }
        return result
        
    }
    
    private func allThreadBacktraceString() -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self.contentString(with: "AllThread Backtrace", content: self.model.allThreadBacktrace, newline: true))
        let  range = result.string.NS.range(of: self.model.allThreadBacktrace!)
        if range.location != NSNotFound {
            let att: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Courier", size: 6)!,
                                                      NSAttributedString.Key.foregroundColor: UIColor.white]
            result.setAttributes(att, range: range)
            
        }
        return result
        
    }
    
}
