//
//  UICollectionView+MagiPhotoBrowser.swift
//  MagiPhotoBrowser_Example
//
//  Created by anran on 2018/10/26.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView: MagiNamespaceWrappable {}

extension MagiTypeWrapperProtocol where MagiWrappedType == UICollectionView {
    
    /// 注册Cell
    public func registerCell<T: UICollectionViewCell>(_ type: T.Type) {
        let identifier = String(describing: type.self)
        magiWrappedValue.register(type, forCellWithReuseIdentifier: identifier)
    }
    
    /// 取重用Cell
    public func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: type.self)
        guard let cell = magiWrappedValue.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("\(type.self) was not registered")
        }
        return cell
    }
    
}
