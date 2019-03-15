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
 
    
}
