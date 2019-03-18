//
//  UIWindow+MagiEye.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    
    fileprivate class var hookWindow: UIWindow? {
        get {
            return objc_getAssociatedObject(
                self,
                &MagiDefine.Key.Associated.HookWindow)
                as? UIWindow
        }
        set {
            objc_setAssociatedObject(
                self,
                &MagiDefine.Key.Associated.HookWindow,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
 
    func makeEye(with configuration: Configuration) {
        MagiEyeController.shared.configuration = configuration
        
        var rect = CGRect(x: self.frame.size.width - 48, y: self.frame.size.height - 160, width: 48, height: 48)
        if let location = configuration.control.location {
            rect.origin = location
        }
        
        var image = UIImage(named: "GodEye.bundle/eye",
                            in: Bundle(for: MagiEyeController.classForCoder()),
                            compatibleWith: nil)
        if image == nil {
            // for carthage, image in framework
            image = UIImage(named: "eye", in: Bundle(for: MagiEyeController.classForCoder()), compatibleWith: nil)
        }
        let btn = AssistiveButton(frame: rect, normalImage: image!)
        btn.didTap = { () -> () in
            if MagiEyeController.shared.isShowing {
                MagiEyeController.hide()
            }else {
                MagiEyeController.show()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
            self.addSubview(btn)
        }
        
        UIWindow.hookWindow = self
        
        var orig = #selector(UIWindow.sendEvent(_:))
        var alter = #selector(UIWindow.app_sendEvent(_:))
        _ = UIWindow.swizzleInstanceMethod(origSelector: orig, toAlterSelector: alter)
        
        
        orig = #selector(UIResponder.motionEnded(_:with:))
        alter = #selector(UIResponder.app_motionEnded(_:with:))
        _ = UIResponder.swizzleInstanceMethod(origSelector: orig, toAlterSelector: alter)
    }
    
    
}

extension UIResponder {
    @objc func app_motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        let control = MagiEyeController.shared.configuration?.control
        if control?.enabled ?? false && control?.shakeToShow() ?? false {
            if event?.type == UIEvent.EventType.motion && event?.subtype == UIEvent.EventSubtype.motionShake {
                if MagiEyeController.shared.isShowing {
                    MagiEyeController.hide()
                }else {
                    MagiEyeController.show()
                }
            }
        }
        self.app_motionEnded(motion, with: event)
    }
}

extension UIWindow {
    
    
    @objc fileprivate func app_sendEvent(_ event: UIEvent) {
        if self.canHandle(event: event) {
            self.handle(event: event)
        }
        
        self.app_sendEvent(event)
    }
    
    private func canHandle(event:UIEvent) -> Bool {
        
        if UIWindow.hookWindow == self {
            let control = MagiEyeController.shared.configuration?.control
            
            if control?.enabled ?? false && event.type == .touches {
                let touches = event.allTouches
                
                if touches?.count == control?.touchesToShow() {
                    return true
                }
            }
        }
        
        return false
    }
    
    private func handle(event:UIEvent) {
        guard let touches = event.allTouches else {
            return
        }
        
        var allUp = true; var allDown = true; var allLeft = true; var allRight = true
        
        touches.forEach { (touch:UITouch) in
            
            if touch.location(in: self).y <= touch.previousLocation(in: self).y {
                allDown = false
            }
            
            if touch.location(in: self).y >= touch.previousLocation(in: self).y {
                allUp = false
            }
            
            if touch.location(in: self).x <= touch.previousLocation(in: self).x {
                allLeft = false
            }
            
            if touch.location(in: self).x >= touch.previousLocation(in: self).x {
                allRight = false
            }
        }
        
        switch UIApplication.shared.statusBarOrientation {
        case .portraitUpsideDown:
            self.handleConsole(show: allDown, hide: allUp)
        case .landscapeLeft:
            self.handleConsole(show: allRight, hide: allLeft)
        case .landscapeRight:
            self.handleConsole(show: allLeft, hide: allRight)
        default:
            self.handleConsole(show: allUp, hide: allDown)
        }
    }
    
    private func handleConsole(show:Bool,hide:Bool) {
        if show {
            MagiEyeController.show()
        }else if hide {
            MagiEyeController.hide()
        }
    }
}
