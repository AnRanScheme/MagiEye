//
//  MagiCrash.swift
//  MagiCrash
//
//  Created by anran on 2019/3/11.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation
import UIKit

// MARK: - MagiCrashEyeDelegate
public protocol MagiCrashEyeDelegate: NSObjectProtocol {
    func crashEyeDidCatchCrash(with model: MagiCrashModel)
}

// MARK: - WeakMagiCrashEyeDelegate
class WeakMagiCrashEyeDelegate: NSObject {
    
    weak var delegate: MagiCrashEyeDelegate?
    
    init(delegate: MagiCrashEyeDelegate) {
        super.init()
        self.delegate = delegate
    }
    
}

// MARK: - GLOBAL VARIABLE
private var app_old_exceptionHandler:(@convention(c) (NSException) -> Swift.Void)? = nil

// MARK: - MagiCrashEye
public class MagiCrashEye: NSObject {
    
    // MARK: OPEN PROPERTY
    public private(set) static var isOpen: Bool = false
    
    // MARK: PRIVATE PROPERTY
    fileprivate static var delegates = [WeakMagiCrashEyeDelegate]()
    
    // MARK: OPEN FUNCTION
    open class func add(delegate: MagiCrashEyeDelegate) {
        // delete null week delegate
        self.delegates = self.delegates.filter {
            return $0.delegate != nil
        }
        
        // judge if contains the delegate from parameter
        let contains = self.delegates.contains {
            return $0.delegate?.hash == delegate.hash
        }
        // if not contains, append it with weak wrapped
        if contains == false {
            let week = WeakMagiCrashEyeDelegate(delegate: delegate)
            self.delegates.append(week)
        }
        
        if self.delegates.count > 0 {
            self.open()
        }
    }
    
    open class func remove(delegate: MagiCrashEyeDelegate) {
        self.delegates = self.delegates.filter {
            // filter null weak delegate
            return $0.delegate != nil
            }.filter {
                // filter the delegate from parameter
                return $0.delegate?.hash != delegate.hash
        }
        
        if self.delegates.count == 0 {
            self.close()
        }
    }
    
    // MARK: PRIVATE FUNCTION
    private class func open() {
        guard self.isOpen == false else {
            return
        }
        MagiCrashEye.isOpen = true
        app_old_exceptionHandler = NSGetUncaughtExceptionHandler()
        NSSetUncaughtExceptionHandler(MagiCrashEye.RecieveException)
        self.setCrashSignalHandler()
    }
    
    private class func close() {
        guard self.isOpen == true else {
            return
        }
        MagiCrashEye.isOpen = false
        NSSetUncaughtExceptionHandler(app_old_exceptionHandler)
    }
    
    private class func setCrashSignalHandler(){
        signal(SIGABRT, MagiCrashEye.RecieveSignal)
        signal(SIGILL, MagiCrashEye.RecieveSignal)
        signal(SIGSEGV, MagiCrashEye.RecieveSignal)
        signal(SIGFPE, MagiCrashEye.RecieveSignal)
        signal(SIGBUS, MagiCrashEye.RecieveSignal)
        signal(SIGPIPE, MagiCrashEye.RecieveSignal)
        //http://stackoverflow.com/questions/36325140/how-to-catch-a-swift-crash-and-do-some-logging
        signal(SIGTRAP, MagiCrashEye.RecieveSignal)
    }
    
    private static let RecieveException: @convention(c) (NSException) -> Swift.Void = {
        (exteption) -> Void in
        app_old_exceptionHandler?(exteption)
        
        guard MagiCrashEye.isOpen == true else {
            return
        }
        
        let callStack = exteption.callStackSymbols.joined(separator: "\r")
        let reason = exteption.reason ?? ""
        let name = exteption.name
        let appinfo = MagiCrashEye.appInfo()
        let model = MagiCrashModel(type: MagiCrashModelType.exception,
                               name: name.rawValue,
                               reason: reason,
                               appinfo: appinfo,
                               callStack: callStack)
        for delegate in MagiCrashEye.delegates {
            delegate.delegate?.crashEyeDidCatchCrash(with: model)
        }
    }
    
    private static let RecieveSignal : @convention(c) (Int32) -> Void = {
        (signal) -> Void in
        
        guard MagiCrashEye.isOpen == true else {
            return
        }
        
        var stack = Thread.callStackSymbols
        stack.removeFirst(2)
        let callStack = stack.joined(separator: "\r")
        let reason = "Signal \(MagiCrashEye.name(of: signal))(\(signal)) was raised.\n"
        let appinfo = MagiCrashEye.appInfo()
        
        let model = MagiCrashModel(type: MagiCrashModelType.signal,
                                   name: MagiCrashEye.name(of: signal),
                                   reason: reason,
                                   appinfo: appinfo,
                                   callStack: callStack)
        
        for delegate in MagiCrashEye.delegates {
            delegate.delegate?.crashEyeDidCatchCrash(with: model)
        }
        
        MagiCrashEye.killApp()
    }
    
    private class func appInfo() -> String {
        let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") ?? ""
        let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? ""
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") ?? ""
        let deviceModel = UIDevice.current.model
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion
        return "App: \(displayName) \(shortVersion)(\(version))\n" +
            "Device:\(deviceModel)\n" +
        "OS Version:\(systemName) \(systemVersion)"
    }
    
    
    private class func name(of signal: Int32) -> String {
        switch (signal) {
        case SIGABRT:
            return "SIGABRT"
        case SIGILL:
            return "SIGILL"
        case SIGSEGV:
            return "SIGSEGV"
        case SIGFPE:
            return "SIGFPE"
        case SIGBUS:
            return "SIGBUS"
        case SIGPIPE:
            return "SIGPIPE"
        default:
            return "OTHER"
        }
    }
    
    private class func killApp(){
        NSSetUncaughtExceptionHandler(nil)
        
        signal(SIGABRT, SIG_DFL)
        signal(SIGILL, SIG_DFL)
        signal(SIGSEGV, SIG_DFL)
        signal(SIGFPE, SIG_DFL)
        signal(SIGBUS, SIG_DFL)
        signal(SIGPIPE, SIG_DFL)
        
        kill(getpid(), SIGKILL)
    }
    
    
}
