//
//  MagiDefaultPageControlDelegate.swift
//  MagiPhotoBrowser_Example
//
//  Created by anran on 2018/10/26.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

/// 实现了以 UIPageControl 为页码指示器的 Delegate.
open class MagiDefaultPageControlDelegate: MagiPhotoBrowserBaseDelegate {
    
    /// 可指定中心点Y坐标，距离底部值。默认值：iPhoneX为30，非iPhoneX为20
    open lazy var centerBottomY: CGFloat = {
        if #available(iOS 11.0, *) {
            return 30
        }
        return 20
    }()
    
    /// 页码指示器
    open lazy var pageControl: UIPageControl = {
        let pgc = UIPageControl()
        pgc.isEnabled = false
        return pgc
    }()
    
    public override func photoBrowser(_ browser: MagiPhotoBrowser, pageIndexDidChanged pageIndex: Int) {
        super.photoBrowser(browser, pageIndexDidChanged: pageIndex)
        pageControl.currentPage = pageIndex
    }
    
    public override func photoBrowserViewDidLayoutSubviews(_ browser: MagiPhotoBrowser) {
        super.photoBrowserViewDidLayoutSubviews(browser)
        layout()
    }
    
    public override func photoBrowser(_ browser: MagiPhotoBrowser, viewDidAppear animated: Bool) {
        super.photoBrowser(browser, viewDidAppear: animated)
        // 页面出来后，再显示页码指示器
        // 多于一张图才添加到视图
        let totalPages = browser.dataSource.collectionView(browser.collectionView, numberOfItemsInSection: 0)
        if totalPages > 1 {
            browser.view.addSubview(pageControl)
        }
    }
    
    //
    // MARK: - Private
    //
    
    private func layout() {
        guard let browser = self.browser else {
            return
        }
        guard let superView = pageControl.superview else { return }
        let totalPages = browser.dataSource.collectionView(browser.collectionView, numberOfItemsInSection: 0)
        pageControl.numberOfPages = totalPages
        pageControl.currentPage = browser.pageIndex
        pageControl.sizeToFit()
        pageControl.center = CGPoint(x: superView.bounds.width / 2,
                                     y: superView.bounds.maxY - centerBottomY)
        pageControl.isHidden = totalPages <= 1
    }
}

