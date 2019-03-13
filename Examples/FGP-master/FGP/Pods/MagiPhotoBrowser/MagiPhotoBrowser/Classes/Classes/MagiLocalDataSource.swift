//
//  MagiLocalDataSource.swift
//  MagiPhotoBrowser_Example
//
//  Created by anran on 2018/10/26.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public class MagiLocalDataSource: NSObject, MagiPhotoBrowserDataSource {
    
    /// 弱引用 PhotoBrowser
    public weak var browser: MagiPhotoBrowser?
    
    /// 共有多少项
    public var numberOfItemsCallback: () -> Int
    
    /// 每一项的图片对象
    public var localImageCallback: (Int) -> UIImage?
    
    public init(numberOfItems: @escaping () -> Int,
                localImage: @escaping (Int) -> UIImage?) {
        self.numberOfItemsCallback = numberOfItems
        self.localImageCallback = localImage
    }
    
    public func registerCell(for collectionView: UICollectionView) {
        collectionView.magiPhotoBrowser.registerCell(MagiPhotoBrowserBaseCell.self)
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsCallback()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.magiPhotoBrowser.dequeueReusableCell(MagiPhotoBrowserBaseCell.self, for: indexPath)
        cell.imageView.image = localImageCallback(indexPath.item)
        cell.setNeedsLayout()
        return cell
    }
}

