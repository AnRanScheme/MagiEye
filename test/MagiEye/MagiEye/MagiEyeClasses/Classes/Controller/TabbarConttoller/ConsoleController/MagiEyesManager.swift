//
//  EyesManager.swift
//
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

class EyesManager: NSObject {
    
    static let shared = EyesManager()
    
    weak var delegate: ConsoleController?
    
    fileprivate lazy var aslEye: MagiASL = { [unowned self] in
        let new = MagiASL()
        new.delegate = self.delegate 
        return new
    }()
    
    fileprivate lazy var catonEye: MagiCatonEye = { [unowned self] in
        let new = MagiCatonEye()
        new.delegate = self.delegate 
        return new
    }()
    
    fileprivate lazy var leakEye: MagiLeakEye = { [unowned self] in
        let new = MagiLeakEye()
        new.delegate = self.delegate
        return new
    }()
}

//--------------------------------------------------------------------------
// MARK: - ASL EYE
//--------------------------------------------------------------------------
extension EyesManager {
    
    func isASLEyeOpening() -> Bool {
        return self.aslEye.isOpening
    }
    
    /// open asl eye
    func openASLEye() {
        self.aslEye.delegate = self.delegate
        self.aslEye.open(with: 1)
    }
    
    /// close asl eys
    func closeASLEye() {
        self.aslEye.close()
    }
}

//--------------------------------------------------------------------------
// MARK: - LOG4G
//--------------------------------------------------------------------------
extension EyesManager {
    
    func isMagiLogEyeOpening() -> Bool {
        return MagiLog.delegateCount > 0
    }
    
    func openMagiLogEye() {
        MagiLog.add(delegate: self.delegate!)
    }
    
    func closeMagiLogEye() {
        MagiLog.remove(delegate: self.delegate!)
    }
}

//--------------------------------------------------------------------------
// MARK: - CRASH
//--------------------------------------------------------------------------
extension EyesManager {
    
    func isCrashEyeOpening() -> Bool {
        return MagiCrashEye.isOpen
    }
    
    func openCrashEye() {
        MagiCrashEye.add(delegate: self.delegate!)
    }
    
    func closeCrashEye() {
        MagiCrashEye.remove(delegate: self.delegate!)
    }
}

//--------------------------------------------------------------------------
// MARK: - NETWORK
//--------------------------------------------------------------------------
extension EyesManager {
    
    func isNetworkEyeOpening() -> Bool {
        return MagiNetworkEye.isWatching
    }
    
    func openNetworkEye() {
        MagiNetworkEye.add(observer: self.delegate!)
    }
    
    func closeNetworkEye() {
        MagiNetworkEye.remove(observer: self.delegate!)
    }
}

//--------------------------------------------------------------------------
// MARK: - ANREye
//--------------------------------------------------------------------------
extension EyesManager {
    func isCatonEyeOpening() -> Bool {
        return self.catonEye.isOpening
    }
    
    func openCatonEye() {
        self.catonEye.open(with: 2)
    }
    
    func closeCatonEye() {
        self.catonEye.close()
    }
}

extension EyesManager {
    
    func isLeakEyeOpening() -> Bool {
        return self.leakEye.isOpening
    }
    
    func openLeakEye() {
        self.leakEye.open()
    }
    
    func closeLeakEye() {
        self.leakEye.close()
    }
    
}
