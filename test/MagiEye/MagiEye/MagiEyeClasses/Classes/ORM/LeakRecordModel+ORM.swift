//
//  LeakRecordModel+ORM.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

extension LeakRecordModel: RecordORMProtocol {
    
    static var type: RecordType {
        return RecordType.leak
    }
    
    func mappingToRelation() -> [Setter] {
        return [LeakRecordModel.col.clazz <- self.clazz,
                LeakRecordModel.col.address <- self.address]
    }
    
    static func mappingToObject(with row: Row) -> LeakRecordModel {
        return LeakRecordModel(clazz: row[LeakRecordModel.col.clazz],
                               address: row[LeakRecordModel.col.address])
    }
    
    static func configure(tableBuilder: TableBuilder) {
        tableBuilder.column(LeakRecordModel.col.clazz)
        tableBuilder.column(LeakRecordModel.col.address)
    }
    
    static func configure(select table:Table) -> Table {
        return table.select(LeakRecordModel.col.clazz,
                            LeakRecordModel.col.address)
    }
    
    func attributeString() -> NSAttributedString {
        return LeakRecordViewModel(self).attributeString()
    }
    
    class col: NSObject {
        static let clazz = Expression<String>("clazz")
        static let address = Expression<String>("address")
    }
    
}

