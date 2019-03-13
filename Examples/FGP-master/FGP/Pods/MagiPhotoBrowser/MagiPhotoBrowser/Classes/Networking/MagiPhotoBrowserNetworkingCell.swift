//
//  MagiPhotoBrowserNetworkingCell.swift
//  MagiPhotoBrowser_Example
//
//  Created by anran on 2018/10/26.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

/// 可展示两级资源。比如首先展示模糊的图片，然后展示清晰的图片
open class MagiPhotoBrowserNetworkingCell: MagiPhotoBrowserBaseCell {
    
    public let progressView = MagiPhotoBrowserProgressView()
    
    /// 初始化
    open override func setupViews() {
        progressView.isHidden = true
        contentView.addSubview(progressView)
    }
    
    /// 布局
    open override func layoutSubviews() {
        super.layoutSubviews()
        progressView.center = CGPoint(x: contentView.bounds.width / 2, y: contentView.bounds.height / 2)
    }
    
    /// 刷新数据
    open func reloadData(photoLoader: MagiPhotoLoader,
                         localImage: UIImage?,
                         autoloadURLString: String?) {
        // 重置环境
        progressView.isHidden = true
        progressView.progress = 0
        // url是否有效
        guard let urlString = autoloadURLString,let url = URL(string: urlString) else {
            imageView.image = localImage
            setNeedsLayout()
            return
        }
        // 取缓存
        let image = photoLoader.imageCached(on: imageView, url: url)
        let placeholder = image ?? localImage
        // 加载
        photoLoader.setImage(on: imageView, url: url, placeholder: placeholder, progressBlock: { receivedSize, totalSize in
            if totalSize > 0 {
                self.progressView.progress = CGFloat(receivedSize) / CGFloat(totalSize)
                if receivedSize < totalSize {
                    self.progressView.isHidden = false
                }
            } else {
                self.progressView.progress = 0
            }
        }) {
            self.progressView.isHidden = true
            self.setNeedsLayout()
        }
        setNeedsLayout()
    }
}
