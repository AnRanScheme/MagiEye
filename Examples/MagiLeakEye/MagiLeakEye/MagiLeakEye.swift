//
//  MagiLeakEye.swift
//  MagiLeakEye
//
//  Created by anran on 2019/3/14.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

// MARK: - MagiLeakEyeDelegate
@objc
protocol MagiLeakEyeDelegate: NSObjectProtocol {
    @objc optional func leakEye(_ leakEye: MagiLeakEye, didCatchLeak object: NSObject)
}

//--------------------------------------------------------------------------
// MARK: - LeakEye
//--------------------------------------------------------------------------
open class MagiLeakEye: NSObject {
    
   
    // MARK: OPEN PROPERTY
    weak var delegate: MagiLeakEyeDelegate?
    open var isOpening: Bool {
        get {
            return self.timer?.isValid ?? false
        }
    }

    // MARK: LIFE CYCLE
    public override init() {
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receive),
            name: NSNotification.Name.receive,
            object: nil)
    }
    
   
    // MARK: OPEN FUNCTION
    open func open() {
        Preparer.binding()
        self.startPingTimer()
    }
    
    open func close() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func startPingTimer() {
        if Thread.isMainThread == false {
            DispatchQueue.main.async {
                self.startPingTimer()
                return
            }
        }
        close()
        timer = Timer.scheduledTimer(timeInterval: 0.5,
                                          target: self,
                                          selector: #selector(scan),
                                          userInfo: nil,
                                          repeats: true)
        
    }
    
    
    // MARK: PRIVATE FUNCTION
    
    @objc private func scan()  {
        NotificationCenter.default.post(
            name: NSNotification.Name.scan,
            object: nil)
    }
    
    @objc private func receive(notif: NSNotification) {
        guard let leakObj = notif.object as? NSObject else {
            return
        }
        delegate?.leakEye?(self, didCatchLeak: leakObj)
    }
    
    
    // MARK: PRIVATE PROPEERTY
    private var timer: Timer?
}
