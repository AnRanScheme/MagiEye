//
//  MagiPhotoBrowserTransitioning.swift
//  MagiPhotoBrowser_Example
//
//  Created by anran on 2018/10/26.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

open class MagiPhotoBrowserTransitioning: NSObject, MagiPhotoBrowserTransitioningDelegate {
    
    /// 弱引用 PhotoBrowser
    public weak var browser: MagiPhotoBrowser?
    
    public var maskAlpha: CGFloat {
        set {
            presentCtrl?.maskView.alpha = newValue
        }
        get {
            return presentCtrl?.maskView.alpha ?? 0
        }
    }
    
    /// present转场动画
    open var presentingAnimator: UIViewControllerAnimatedTransitioning?
    
    /// dismiss转场动画
    open var dismissingAnimator: UIViewControllerAnimatedTransitioning?
    
    private weak var presentCtrl: MagiPhotoBrowserPresentationController?
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentingAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissingAnimator
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let ctrl = MagiPhotoBrowserPresentationController(presentedViewController: presented, presenting: presenting)
        presentCtrl = ctrl
        return ctrl
    }
}

