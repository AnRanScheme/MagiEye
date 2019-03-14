//
//  MagiASLLog.swift
//  MagiASLLog
//
//  Created by anran on 2019/3/7.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation
import asl

/// 类专属协议
@objc
public protocol MagiASLDelegate: class {
    @objc
    optional func aslLog(_ aslLog: MagiASL, catchLogs logs: [String])
}

open class MagiASL: NSObject {
    
    fileprivate var timer: Timer?
    fileprivate var lastMessageID: Int32 = 0
    fileprivate var queue = DispatchQueue(label: "MagiASLQueue")
    open weak var delegate: MagiASLDelegate?
    
    open var isOpening: Bool {
        get {
            return timer?.isValid ?? false
        }
    }
    
    open func open(with interval: TimeInterval) {
        self.timer = Timer.scheduledTimer(timeInterval: interval,
                                          target: self,
                                          selector: #selector(pollingLogs),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    open func close() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc
    fileprivate func pollingLogs() {
        if #available(iOS 10.0, *) {
            //系统版本高于10.0
        }
            
        else {
            //系统版本低于10.0
            queue.async {
                let logs = self.retrieveLogs()
                if logs.count == 0 { return }
                DispatchQueue.main.async {
                    self.delegate?.aslLog?(self, catchLogs: logs)
                }
            }
        }
    }
    
    fileprivate func retrieveLogs() -> [String] {
        var logs = [String]()
        
        guard let query: aslmsg = initQuery() else { return logs }
        if #available(iOS 10.0, *) {
          //系统版本高于10.0
            
        }
        else {
            //系统版本低于10.0
            let response: aslresponse? = asl_search(nil, query)
            guard response != nil else {
                return logs
            }
            
            var message = asl_next(response)
            while (message != nil) {
                let log = parserLog(from: message!)
                logs.append(log)
                
                message = asl_next(response)
            }
            asl_free(response)
            asl_free(query)
        }
        return logs
    }
    
    fileprivate func parserLog(from message: aslmsg) ->String {
        if #available(iOS 10.0, *) {
            //系统版本高于10.0
            return ""
        }
        else {
            //系统版本低于10.0
            let content = asl_get(message, ASL_KEY_MSG)!
            let msg_id = asl_get(message, ASL_KEY_MSG_ID)
            
            let m = atoi(msg_id)
            if (m != 0) {
                self.lastMessageID = m
            }
            return String(cString: content, encoding: String.Encoding.utf8)!
        }
        
    }
    
    fileprivate func initQuery() -> aslmsg? {
        
        if #available(iOS 10.0, *) {
            //系统版本高于10.0
            return nil
        }
        else {
            let query: aslmsg = asl_new(UInt32(ASL_TYPE_QUERY))
            //set BundleIdentifier to ASL_KEY_FACILITY
            let bundleIdentifier = (Bundle.main.bundleIdentifier! as NSString).utf8String
            asl_set_query(query, ASL_KEY_FACILITY, bundleIdentifier, UInt32(ASL_QUERY_OP_EQUAL))
            //set pid to ASL_KEY_PID
            let pid = NSString(format: "%d", getpid()).cString(using: String.Encoding.utf8.rawValue)
            asl_set_query(query, ASL_KEY_PID, pid, UInt32(ASL_QUERY_OP_NUMERIC))
            
            if self.lastMessageID != 0 {
                let m = NSString(format: "%d", self.lastMessageID).utf8String
                asl_set_query(query, ASL_KEY_MSG_ID, m, UInt32(ASL_QUERY_OP_GREATER | ASL_QUERY_OP_NUMERIC));
            }
            return query
        }
    }
    
}
