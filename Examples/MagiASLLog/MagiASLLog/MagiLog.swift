//
//  MagiLog.swift
//  MagiASLLog
//
//  Created by anran on 2019/3/7.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

// MARK: - MagiLogDelegate
@objc
public protocol MagiLogDelegate: NSObjectProtocol {
    func logDidRecord(with model: MagiLogModel)
}

open class MagiLog: NSObject {
    //MARK: - Private Variable
    
    /// singleton for Log4g
    fileprivate static let shared = MagiLog()
    /// log queue
    private let queue = DispatchQueue(label: "MagiLog")
    /// weak delegates
    fileprivate var delegates = NSHashTable<MagiLogDelegate>(options: .weakMemory)
    
    //--------------------------------------------------------------------------
    // MARK: OPEN FUNCTION
    //--------------------------------------------------------------------------
    
    /// record a log type message
    ///
    /// - Parameters:
    ///   - message: log message
    ///   - file: file which call the api
    ///   - line: line number at file which call the api
    ///   - function: function name which call the api
    open class func log(_ message: Any = "",
                        file: String = #file,
                        line: Int = #line,
                        function: String = #function) {
        self.shared.record(type: .info,
                           thread: Thread.current,
                           message: "\(message)",
            file: file,
            line: line,
            function: function)
    }
    
    /// record a warning type message
    ///
    /// - Parameters:
    ///   - message: warning message
    ///   - file: file which call the api
    ///   - line: line number at file which call the api
    ///   - function: function name which call the api
    open class func warning(_ message: Any = "",
                            file: String = #file,
                            line: Int = #line,
                            function: String = #function) {
        self.shared.record(type: .warning,
                           thread: Thread.current,
                           message: "\(message)",
            file: file,
            line: line,
            function: function)
    }
    
    /// record an error type message
    ///
    /// - Parameters:
    ///   - message: error message
    ///   - file: file which call the api
    ///   - line: line number at file which call the api
    ///   - function: function name which call the api
    open class func error(_ message: Any = "",
                          file: String = #file,
                          line: Int = #line,
                          function: String = #function) {
        self.shared.record(type: .error,
                           thread: Thread.current,
                           message: "\(message)",
            file: file,
            line: line,
            function: function)
    }
    
    //--------------------------------------------------------------------------
    // MARK: PRIVATE FUNCTION
    //--------------------------------------------------------------------------
    
    /// record message base function
    ///
    /// - Parameters:
    ///   - type: log type
    ///   - thread: thread which log the messsage
    ///   - message: log message
    ///   - file: file which call the api
    ///   - line: line number at file which call the api
    ///   - function: function name which call the api
    private func record(type: MagiLogType,
                        thread: Thread,
                        message: String,
                        file: String,
                        line: Int,
                        function: String) {
        self.queue.async {
            let model = MagiLogModel(type: type,
                                     thread: thread,
                                     message: message,
                                     file: self.name(of: file),
                                     line: line,
                                     function: function)
            print(message)
            self.delegates.allObjects.forEach({ (delegate) in
                delegate.logDidRecord(with: model)
            })
            /* 无限循环
            while let delegate = self.delegates.objectEnumerator().nextObject() {
                if delegate is MagiLogDelegate {
                    (delegate as! MagiLogDelegate).logDidRecord(with: model)
                }
            }
            */
        }
    }
    
    /// get the name of file in filepath
    ///
    /// - Parameter file: path of file
    /// - Returns: filename
    private func name(of file:String) -> String {
        return URL(fileURLWithPath: file).lastPathComponent
    }

}

//--------------------------------------------------------------------------
// MARK: - Delegate Fucntion Extension
//--------------------------------------------------------------------------
extension MagiLog {
    
    open class var delegateCount: Int {
        get {
            return self.shared.delegates.count
        }
    }
    
    open class func add(delegate: MagiLogDelegate) {
        let log = self.shared
        
        log.delegates.add(delegate)
    }
    
    open class func remove(delegate: MagiLogDelegate) {
        let log = self.shared
        
        log.delegates.remove(delegate)
    }
}
