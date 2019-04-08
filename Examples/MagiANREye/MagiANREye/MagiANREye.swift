//
//  MagiANREye.swift
//  MagiANREye
//
//  Created by anran on 2019/3/11.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

// MARK: - MagiCatonEyeDelegate
@objc
public protocol MagiANREyeDelegate: NSObjectProtocol {
    @objc
    optional func anrEye(
        anrEye: MagiANREye,
        catchWithThreshold threshold: Double,
        mainThreadBacktrace: String?,
        allThreadBacktrace: String?)
}


// MARK: - MagiCatonEye
open class MagiANREye: NSObject {
    
    // MARK: OPEN PROPERTY
    open weak var delegate: MagiANREyeDelegate?
    
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
    open func open(with threshold: Double = 0.4) {
        
        if Thread.current.isMainThread {
            AppBacktrace.main_thread_id = mach_thread_self()
        }
        else {
            DispatchQueue.main.async {
                AppBacktrace.main_thread_id = mach_thread_self()
            }
        }
        pingThread = AppPingThread()
        pingThread?.start(
            threshold: threshold,
            handler: { [weak self] in
                guard let self = `self` else { return }
                let main = AppBacktrace.mainThread()
                let all = AppBacktrace.allThread()
                self.delegate?.anrEye?(anrEye: self,
                                       catchWithThreshold: threshold,
                                       mainThreadBacktrace: main,
                                       allThreadBacktrace: all)
        })
        
    }
    
    open func close() {
        pingThread?.cancel()
    }
   
    deinit {
        pingThread?.cancel()
    }
    
}


// MARK: - AppPingThread
private class AppPingThread: Thread {
    
    // MARK: OPEN DEFINE
    public typealias AppPingThreadCallBack = () -> Void
    // MARK: PRIVATE PROPERTY
    private let semaphore = DispatchSemaphore(value: 0)
    private var isMainThreadBlock = false
    private var threshold: Double = 0.4
    private var handler: (()->Void)?
    
    func start(threshold: Double = 0.4, handler: @escaping AppPingThreadCallBack) {
        self.threshold = threshold
        self.handler = handler
        start()
    }
    
    override func main() {
        while !isCancelled {
            isMainThreadBlock = true
            DispatchQueue.main.async {
                self.isMainThreadBlock = false
                self.semaphore.signal()
            }
            Thread.sleep(forTimeInterval: threshold)
            if isMainThreadBlock  {
                handler?()
            }
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        }
    }
    
}
