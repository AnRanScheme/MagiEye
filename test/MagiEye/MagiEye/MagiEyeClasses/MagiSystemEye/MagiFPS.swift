//
//  MagiFps.swift
//  MagiSystemEye
//
//  Created by anran on 2019/3/13.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol MagiFPSDelegate: class {
    @objc optional func fps(fps: MagiFPS, currentFPS: Double)
}

open class MagiFPS: NSObject {
    
    private lazy var displayLink: CADisplayLink = { [unowned self] in
        let new = CADisplayLink(target: self,
                                selector: #selector(displayLinkHandler))
        new.isPaused = true
        new.add(to: .main,
                forMode: .common)
        
        return new
        }()
    
    private var count:Int = 0
    
    private var lastTime: CFTimeInterval = 0.0
    
    open var isEnable: Bool = true
    
    open var updateInterval: Double = 1.0
    
    open weak var delegate: MagiFPSDelegate?
    
    public override init() {
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillResignActiveNotification),
            name: UIApplication.willResignActiveNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActiveNotification),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
    }
    
    open func open() {
        guard self.isEnable == true else {
            return
        }
        self.displayLink.isPaused = false
    }
    
    open func close() {
        guard self.isEnable == true else {
            return
        }
        
        self.displayLink.isPaused = true
    }
    
    
    @objc
    private func applicationWillResignActiveNotification() {
        guard self.isEnable == true else {
            return
        }
        
        self.displayLink.isPaused = true
    }
    
    @objc
    private func applicationDidBecomeActiveNotification() {
        guard self.isEnable == true else {
            return
        }
        self.displayLink.isPaused = false
    }
    
    @objc
    private func displayLinkHandler() {
        if #available(iOS 10.0, *) {
            self.count += self.displayLink.preferredFramesPerSecond
        }
        else {
           self.count += self.displayLink.frameInterval
        }
        let interval = self.displayLink.timestamp - self.lastTime
        
        guard interval >= self.updateInterval else {
            return
        }
        
        self.lastTime = self.displayLink.timestamp
        let fps = Double(self.count) / interval
        self.count = 0
        
        self.delegate?.fps?(fps: self, currentFPS: round(fps))
        
    }

}

