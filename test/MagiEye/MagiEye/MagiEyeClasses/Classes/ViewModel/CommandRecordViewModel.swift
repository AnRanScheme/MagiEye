//
//  CommandRecordViewModel.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

class CommandRecordViewModel: BaseRecordViewModel {
    
    private(set) var model:CommandRecordModel
    
    init(_ model: CommandRecordModel) {
        self.model = model
        super.init()
    }
    
    func attributeString() -> NSAttributedString {
        
        let result = NSMutableAttributedString()
        
        result.append(self.headerString())
        result.append(self.actionString())
        return result
    }
    
    private func headerString() -> NSAttributedString {
        return self.headerString(with: "Command", content: self.model.command, color: UIColor(hex: 0xB754C4))
    }
    
    private func actionString() -> NSAttributedString {
        return NSAttributedString(string: self.model.actionResult, attributes: self.attributes)
    }
    
    
}
