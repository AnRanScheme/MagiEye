//
//  CatonRecordModel.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

extension CatonRecordModel: RecordORMProtocol {
    
    static var type: RecordType {
        return RecordType.log
    }
    
    func mappingToRelation() -> [Setter] {
        return [CatonRecordModel.col.threshold <- self.threshold,
                CatonRecordModel.col.mainThreadBacktrace <- self.mainThreadBacktrace,
                CatonRecordModel.col.allThreadBacktrace <- self.allThreadBacktrace]
    }
    
    static func mappingToObject(with row: Row) -> CatonRecordModel {
        return CatonRecordModel(threshold: row[CatonRecordModel.col.threshold],
                                mainThreadBacktrace: row[CatonRecordModel.col.mainThreadBacktrace],
                                allThreadBacktrace: row[CatonRecordModel.col.allThreadBacktrace])
    }
    
    static func configure(tableBuilder: TableBuilder) {
        tableBuilder.column(CatonRecordModel.col.threshold)
        tableBuilder.column(CatonRecordModel.col.mainThreadBacktrace)
        tableBuilder.column(CatonRecordModel.col.allThreadBacktrace)
    }
    
    static func configure(select table: Table) -> Table {
        return table.select(CatonRecordModel.col.threshold,
                            CatonRecordModel.col.mainThreadBacktrace,
                            CatonRecordModel.col.allThreadBacktrace)
    }
    
    
    
    static func prepare(sequence: AnySequence<Row>) -> [CatonRecordModel] {
        return sequence.map { (row:Row) -> CatonRecordModel in
            return CatonRecordModel(threshold: row[CatonRecordModel.col.threshold],
                                    mainThreadBacktrace: row[CatonRecordModel.col.mainThreadBacktrace],
                                    allThreadBacktrace: row[CatonRecordModel.col.allThreadBacktrace])
        }
    }
    
    func attributeString() -> NSAttributedString {
        return CatonRecordViewModel(self).attributeString()
    }
    
    class col: NSObject {
        static let threshold = Expression<Double?>("threshold")
        static let mainThreadBacktrace = Expression<String?>("mainThreadBacktrace")
        static let allThreadBacktrace = Expression<String?>("allThreadBacktrace")
    }
}
