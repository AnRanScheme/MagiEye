//
//  MagiCatonEye.swift
//  MagiCatonEye
//
//  Created by anran on 2019/3/11.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

// MARK: - MagiCatonEyeDelegate
@objc
public protocol MagiCatonEyeDelegate: class {
    @objc
    optional func catonEye(catonEye: MagiCatonEye,
                           catchWithThreshold threshold: Double,
                           mainThreadBacktrace: String?,
                           allThreadBacktrace: String?)
}


// MARK: - MagiCatonEye
open class MagiCatonEye: NSObject {
    
    // MARK: OPEN PROPERTY
    open weak var delegate: MagiCatonEyeDelegate?
    open var isOpening: Bool {
        get {
            guard let pingThread = self.pingThread else {
                return false
            }
            return !pingThread.isCancelled
        }
    }
    // MARK: PRIVATE PROPERTY
    private var pingThread: AppPingThread?
    
    // MARK: OPEN FUNCTION
    open func open(with threshold: Double) {
        
        if Thread.current.isMainThread {
            AppBacktrace.main_thread_id = mach_thread_self()
        }
        else {
            DispatchQueue.main.async {
                AppBacktrace.main_thread_id = mach_thread_self()
            }
        }
        self.pingThread = AppPingThread()
        self.pingThread?.start(threshold: threshold,
                               handler: { [weak self] in
                                guard let self = `self` else { return }
                                let main = AppBacktrace.mainThread()
                                let all = AppBacktrace.allThread()
                                self.delegate?.catonEye?(catonEye: self,
                                                         catchWithThreshold: threshold,
                                                         mainThreadBacktrace: main,
                                                         allThreadBacktrace: all)
                                
        })
        
    }
    
    open func close() {
        self.pingThread?.cancel()
    }
    
    // MARK: LIFE CYCLE
    deinit {
        self.pingThread?.cancel()
    }
    
}


// MARK: - GLOBAL DEFINE
public typealias AppPingThreadCallBack = () -> Void

// MARK: - AppPingThread
private class AppPingThread: Thread {
    
    private let semaphore = DispatchSemaphore(value: 0)
    private var isMainThreadBlock = false
    private var threshold: Double = 0.4
    fileprivate var handler: (() -> Void)?
    
    func start(threshold: Double, handler: @escaping AppPingThreadCallBack) {
        self.handler = handler
        self.threshold = threshold
        self.start()
    }
    
    override func main() {
        
        while self.isCancelled == false {
            self.isMainThreadBlock = true
            DispatchQueue.main.async {
                self.isMainThreadBlock = false
                self.semaphore.signal()
            }
            Thread.sleep(forTimeInterval: threshold)
            if isMainThreadBlock  {
                handler?()
            }
            _ = self.semaphore.wait(
                timeout: DispatchTime.distantFuture)
            
        }
        
    }
    
}
