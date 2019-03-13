//
//  QUPwdWindow.swift
//  FGP
//
//  Created by briceZhao on 2018/8/26.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit

typealias Completion = (Any) -> Void

class QUPwdWindow: UIWindow {
    
    static let instance: QUPwdWindow = QUPwdWindow(frame: UIScreen.main.bounds)
    
    class func shareWindow() -> QUPwdWindow {
        instance.windowLevel = UIWindow.Level.normal + 1
        instance.backgroundColor = kAppBackColor
        instance.nav = UINavigationController()
        instance.nav.view.backgroundColor = kAppBackColor
        instance.nav.pushViewController(UIViewController(), animated: false)
        
        return instance
    }
    
    var nav: UINavigationController = UINavigationController()
    
    var completion: Completion?
    
    var blockKey: String?
    
    var isStay: String?
    
    var pwdDelegate: QUPwdWindowDelegate?
    
    
    func show() {
        if !self.isKeyWindow {
            self.makeKey()
            self.isHidden = true
        }
    }
    
    func hideWindow() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.0
            self.nav.popToRootViewController(animated: true)
        }) { (finish: Bool) in
            self.isHidden = true
            self.alpha = 1.0
        }
        self.resignKey()
    }
    
    func showWithLogin(animated: Bool) {
        self.show()
        self.completion = nil
        self.blockKey = nil
        self.isStay = "N"
        self.pushLogin(animated: animated)
    }
    
    func pushLogin(animated: Bool) {
        //清空用户信息
        let ctrl = FGPLoginViewController()
        ctrl.pwdDelegate = self.pwdDelegate
        self.nav.pushViewController(ctrl, animated: animated)
    }
}

extension QUPwdWindow: QUPwdWindowDelegate {
    
}


