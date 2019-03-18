//
//  RecordType.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

private var unreadDic = [RecordType.log: 0,
                         RecordType.crash: 0,
                         RecordType.network: 0,
                         RecordType.caton: 0,
                         RecordType.leak: 0]

enum RecordType {
    case log
    case crash
    case network
    case caton
    case leak
    case command
}

// MARK: Unred
extension RecordType {
    func unread() -> Int {
        return unreadDic[self] ?? 0
    }
    
    func addUnread() {
        unreadDic[self] = self.unread() + 1
    }
    
    func cleanUnread() {
        unreadDic[self] = 0
    }
}

// MARK: Title
extension RecordType {
    func title() -> String {
        switch self {
        case .log:
            return "Log"
        case .crash:
            return "Crash"
        case .network:
            return "Network"
        case .caton:
            return "Caton"
        case .leak:
            return "Leak"
        case .command:
            return "Terminal"
        }
    }
    
    func detail() -> String {
        switch self {
        case .log:
            return "asl and logger information"
        case .crash:
            return "crash call stack information"
        case .network:
            return "request and response information"
        case .caton:
            return "caton call stack information"
        case .leak:
            return "memory leak information"
        case .command:
            return "terminal with commands and results"
        }
    }
}


// MARK: - ORM
extension RecordType {
    
    func model() -> RecordORMProtocol.Type? {
        var clazz: AnyClass?
        switch self {
        case .log:
            clazz = LogRecordModel.classForCoder()
        case .crash:
            clazz = CrashRecordModel.classForCoder()
        case .network:
            clazz = NetworkRecordModel.classForCoder()
        case .caton:
            clazz = CatonRecordModel.classForCoder()
        case .command:
            clazz = CommandRecordModel.classForCoder()
        default:
            clazz = nil
        }
        
        return clazz as? RecordORMProtocol.Type
    }
    
    func tableName() -> String {
        switch self {
        case .log:
            return "t_log"
        case .crash:
            return "t_crash"
        case .network:
            return "t_natwork"
        case .caton:
            return "t_caton"
        case .leak:
            return "t_leak"
        case .command:
            return "t_command"
        }
    }
}
