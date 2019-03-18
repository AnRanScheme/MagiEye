//
//  MagiEyeController+Show.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

extension MagiEyeController {
    
    var isAnimating: Bool {
        get {
            guard let _isAnimating = objc_getAssociatedObject(
                self,
                &MagiDefine.Key.Associated.Animation)
                as? Bool else {  return false }
            return  _isAnimating
        }
        
        set {
            objc_setAssociatedObject(
                self,
                &MagiDefine.Key.Associated.Animation,
                newValue,
                .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var isShowing: Bool {
        get {
            guard let _isShowing = objc_getAssociatedObject(
                self,
                &MagiDefine.Key.Associated.Showing)
                as? Bool else {  return false }
            return  _isShowing
        }
        
        set {
            objc_setAssociatedObject(
                self,
                &MagiDefine.Key.Associated.Showing,
                newValue,
                .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    class func show() {
        shared.showConsole()
    }
    
    class func hide() {
        shared.hideConsole()
    }
    
    private func hideConsole() {
        if isAnimating == false && view.superview != nil {
            _ = UIApplication.shared.mainWindow()?.findAndResignFirstResponder()
            isAnimating = true
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.4)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStop(#selector(consoleHidden))
            self.view.frame = UIScreen.offscreenFrame()
            UIView.commitAnimations()
        }
    }
    
    private func showConsole() {
        if isAnimating == false && view.superview == nil {
            _ = UIApplication.shared.mainWindow()?.findAndResignFirstResponder()
            
            view.frame = UIScreen.offscreenFrame()
            setViewPlace()
            isAnimating = true
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.4)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStop(#selector(consoleShown))
            view.frame = UIScreen.onscreenFrame()
            view.transform = viewTransform()
            UIView.commitAnimations()
        }
    }
    
    @objc
    private func consoleShown() {
        isShowing = true
        isAnimating = false
        _ = UIApplication.shared.mainWindow()?.findAndResignFirstResponder()
    }
    
    @objc
    private func consoleHidden() {
        isShowing = false
        isAnimating = false
        view.removeFromSuperview()
    }
    
    private func setViewPlace() {
        guard let superView = UIApplication.shared.mainWindow() else {
            return
        }
        superView.addSubview(view)
        
        //bring AssistiveButton to front
        for subview in superView.subviews {
            if subview.isKind(of: AssistiveButton.classForCoder()) {
                superView.bringSubviewToFront(subview)
            }
        }
    }
    
    private func viewTransform() -> CGAffineTransform {
        var angle: Double = 0.0
        switch UIApplication.shared.statusBarOrientation {
        case .portraitUpsideDown:
            angle = Double.pi
        case .landscapeLeft:
            angle = -Double.pi/2
        case .landscapeRight:
            angle = Double.pi/2
        default:
            angle = 0
        }

        return CGAffineTransform(rotationAngle: CGFloat(angle))
    }
}
