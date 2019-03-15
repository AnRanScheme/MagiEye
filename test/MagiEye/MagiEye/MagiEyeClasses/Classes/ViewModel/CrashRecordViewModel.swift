//
//  CrashRecordViewModel.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

class CrashRecordViewModel: BaseRecordViewModel {
    private(set) var model:CrashRecordModel
    
    init(_ model: CrashRecordModel) {
        self.model = model
        super.init()
    }
    
    func attributeString() -> NSAttributedString {
        
        let result = NSMutableAttributedString()
        
        result.append(self.headerString())
        result.append(self.nameString())
        result.append(self.reasonString())
        result.append(self.appinfoString())
        result.append(self.callStackString())
        return result
    }
    
    private func headerString() -> NSAttributedString {
        let type = self.model.type == .exception ? "Exception" : "SIGNAL"
        return self.headerString(with: "CRASH", content: type, color: UIColor(hex: 0xDF1921))
    }
    
    private func nameString() -> NSAttributedString {
        return self.contentString(with: "NAME", content: self.model.name)
    }
    
    private func reasonString() -> NSAttributedString {
        return self.contentString(with: "REASON", content: self.model.reason)
    }
    
    private func appinfoString() -> NSAttributedString {
        return self.contentString(with: "APPINFO", content: self.model.appinfo)
    }
    
    private func callStackString() -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self.contentString(with: "CALL STACK", content: self.model.callStack))
        let  range = result.string.NS.range(of: self.model.callStack)
        if range.location != NSNotFound {
            let att: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Courier", size: 6)!,
                                                      NSAttributedString.Key.foregroundColor: UIColor.white]
            result.setAttributes(att, range: range)
            
        }
        return result
    }
}
