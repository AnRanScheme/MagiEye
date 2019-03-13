//
//  MagiPhotoLoader.swift
//  MagiPhotoBrowser_Example
//
//  Created by anran on 2018/10/26.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

/// PhotoLoader 实现者必须是 NSObject 子类
public protocol MagiPhotoLoader {
    /// 取缓存的图片对象
    ///
    /// - Parameters:
    ///   - imageView: 图片对象
    ///   - url: 图片url
    /// - Returns: 图片
    func imageCached(on imageView: UIImageView, url: URL?) -> UIImage?
    
    ///  加载图片并设置给 imageView
    ///
    /// - Parameters:
    ///   - imageView: 图片对象
    ///   - url: url 为空
    ///   - placeholder: placeholder 为本地图片
    ///   - progressBlock: 进度回调
    ///   - completionHandler: 加载完成回调
    func setImage(on imageView: UIImageView,
                  url: URL?,
                  placeholder: UIImage?,
                  progressBlock: @escaping (_ receivedSize: Int64, _ totalSize: Int64) -> Void,
                  completionHandler: @escaping () -> Void)
}
