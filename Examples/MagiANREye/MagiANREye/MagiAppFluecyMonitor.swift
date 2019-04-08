//
//  MagiAppFluecyMonitor.swift
//  MagiANREye
//
//  Created by anran on 2019/4/1.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

open class MagiAppFluecyMonitor: NSObject {
    
    private var timeOut: Double
    private var isMonitoring: Bool = true
    private var observer: CFRunLoopObserver?
    private var currentActivity: CFRunLoopActivity?
    private let semphore = DispatchSemaphore(value: 0)
    private let eventSemphore = DispatchSemaphore(value: 0)
    private let event_monitor_queue = DispatchQueue(label: "com.anran.event_monitor_queue")
    private let fluecy_monitor_queue = DispatchQueue(label: "com.anran.monitor_queue")
    private let restore_interval: TimeInterval = 5
    private let time_out_interval: TimeInterval = 1
    private let wait_interval: UInt64 = 200 * Darwin.USEC_PER_SEC
    public static let shared = MagiAppFluecyMonitor()
    
    init(timeOut: Double = 0.45) {
        self.timeOut = timeOut
    }
    
    deinit {
        stop()
    }
    
    open func start() {
        if !isMonitoring { return }
        isMonitoring = true
        let runloop = CFRunLoopGetMain()
        let unmanaged = Unmanaged.passRetained(self)
        let uptr = unmanaged.toOpaque()
        let vptr = UnsafeMutableRawPointer(uptr)
       
        var content = CFRunLoopObserverContext(version:0,
                                               info: vptr,
                                               retain:nil,
                                               release:nil,
                                               copyDescription:nil)

        let enterObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                    CFRunLoopActivity.allActivities.rawValue,
                                                    true,
                                                    0,
                                                    callBackObserve(),
                                                    &content)
        CFRunLoopAddObserver(runloop, enterObserver, CFRunLoopMode.commonModes)
        event_monitor_queue.async { [weak self] in
            guard let self = `self` else { return }
            while self.isMonitoring {
                if self.currentActivity == .beforeWaiting {
                    var isTimeout = true
                    DispatchQueue.main.async {
                        isTimeout = false
                    }
                    self.eventSemphore.signal()
                    Thread.sleep(forTimeInterval: TimeInterval(self.wait_interval))
                    if isTimeout {
                        let main = AppBacktrace.mainThread()
                        let all = AppBacktrace.allThread()
                        print("------------------------------------------")
                        print(main)
                        print("------------------------------------------")
                        print(all)
                    }
                    _ = self.eventSemphore.wait(timeout: DispatchTime.distantFuture)
                }
            }
        }
        
        fluecy_monitor_queue.async { [weak self] in
            guard let self = `self` else { return }
            while self.isMonitoring {
                let waitTime = self.semphore.wait(timeout: DispatchTime(uptimeNanoseconds: self.wait_interval))
                if waitTime != .success {
                    if self.observer == nil {
                        self.timeOut = 0
                        self.stop()
                        continue
                    }
                    if self.currentActivity == .beforeSources
                        || self.currentActivity == .afterWaiting {
                        if self.timeOut+1 < 5 {
                            continue
                        }
                        let main = AppBacktrace.mainThread()
                        let all = AppBacktrace.allThread()
                        print("------------------------------------------")
                        print(main)
                        print("------------------------------------------")
                        print(all)
                        Thread.sleep(forTimeInterval: self.restore_interval)
                    }
                }
                self.timeOut = 0
            }
        }
    }
    
    open func stop() {
        if !isMonitoring { return }
        isMonitoring = false
        CFRunLoopRemoveObserver(
            CFRunLoopGetCurrent(),
            observer,
            CFRunLoopMode.commonModes)
        observer = nil
    }
    
    private func callBackObserve()->CFRunLoopObserverCallBack {
        return {(observer, activity, context) -> Void in
            if context == nil {
                return
            }
            let vc = unsafeBitCast(context, to: MagiAppFluecyMonitor.self)
            vc.currentActivity = activity
            vc.semphore.signal()
            switch activity {
            case .entry:
                print("runloop entry")
            case .beforeTimers:
                print("runloop before timers")
            case .beforeSources:
                print("runloop before sources")
            case .beforeWaiting:
                print("runloop after waiting")
            case .afterWaiting:
                print("runloop after waiting")
            case .exit :
                print("runloop exit")
            case .allActivities:
                print("runloop allActivities")
            default:
                break
            }
        }
    }
    
}
