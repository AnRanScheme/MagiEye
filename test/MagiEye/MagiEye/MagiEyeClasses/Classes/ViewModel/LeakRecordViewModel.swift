//
//  LeakRecordViewModel.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

class LeakRecordViewModel: BaseRecordViewModel {
    
    private(set) var model:LeakRecordModel
    
    init(_ model:LeakRecordModel) {
        self.model = model
        super.init()
    }
    
    func attributeString() -> NSAttributedString {
        
        let result = NSMutableAttributedString()
        
        result.append(self.headerString())
        return result
    }
    
    private func headerString() -> NSAttributedString {
        return self.headerString(with: "Leak", content: "[\(self.model.clazz): \(self.model.address)]", color: UIColor(hex: 0xB754C4))
    }
    
    
    
}
