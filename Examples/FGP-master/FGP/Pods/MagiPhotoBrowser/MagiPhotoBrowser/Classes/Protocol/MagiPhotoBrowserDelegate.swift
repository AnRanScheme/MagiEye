//
//  MagiPhotoBrowserDelegate.swift
//  MagiPhotoBrowser_Example
//
//  Created by anran on 2018/10/26.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

/// 视图代理
public protocol MagiPhotoBrowserDelegate: UICollectionViewDelegate {
    
    /// 实现者应弱引用 PhotoBrowser，由 PhotoBrowser 初始化完毕后注入
    var browser: MagiPhotoBrowser? { set get }
    
    /// pageIndex 值改变时回调
    func photoBrowser(_ browser: MagiPhotoBrowser, pageIndexDidChanged pageIndex: Int)
    
    /// 取当前显示页的内容视图。比如是 ImageView.
    func displayingContentView(_ browser: MagiPhotoBrowser, pageIndex: Int) -> UIView?
    
    /// 取转场动画视图
    func transitionZoomView(_ browser: MagiPhotoBrowser, pageIndex: Int) -> UIView?
    
    /// viewDidLoad 即将结束时调用
    func photoBrowserViewDidLoad(_ browser: MagiPhotoBrowser)
    
    /// viewWillAppear 即将结束时调用
    func photoBrowser(_ browser: MagiPhotoBrowser, viewWillAppear animated: Bool)
    
    /// viewWillLayoutSubviews 即将结束时调用
    func photoBrowserViewWillLayoutSubviews(_ browser: MagiPhotoBrowser)
    
    /// viewDidLayoutSubviews 即将结束时调用
    func photoBrowserViewDidLayoutSubviews(_ browser: MagiPhotoBrowser)
    
    /// viewDidAppear 即将结束时调用
    func photoBrowser(_ browser: MagiPhotoBrowser, viewDidAppear animated: Bool)
    
    /// viewWillDisappear 即将结束时调用
    func photoBrowser(_ browser: MagiPhotoBrowser, viewWillDisappear animated: Bool)
    
    /// viewDidDisappear 即将结束时调用
    func photoBrowser(_ browser: MagiPhotoBrowser, viewDidDisappear animated: Bool)
}

