//
//  MagiPhotoBrowserTransitioningDelegate.swift
//  MagiPhotoBrowser_Example
//
//  Created by anran on 2018/10/26.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

/// 转场动画代理
public protocol MagiPhotoBrowserTransitioningDelegate: UIViewControllerTransitioningDelegate {
    
    /// 实现者应弱引用 PhotoBrowser，由 PhotoBrowser 初始化完毕后注入
    var browser: MagiPhotoBrowser? { set get }
    
    /// 蒙板 alpha 值
    var maskAlpha: CGFloat { set get }
}
