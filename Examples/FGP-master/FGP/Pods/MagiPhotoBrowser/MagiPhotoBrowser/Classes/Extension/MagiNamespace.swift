//
//  MagiNamespace.swift
//  MagiPhotoBrowser_Example
//
//  Created by anran on 2018/10/26.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

/// 类型协议  带有 关联类型的协议 和普通的协议是不同的  类似的协议在集合中就有体现 IteratorProtocol
public protocol MagiTypeWrapperProtocol {
    /// 关联类型
    associatedtype MagiWrappedType
    var magiWrappedValue: MagiWrappedType { get }
    init(value: MagiWrappedType)
}

public struct MagiNamespaceWrapper<T>: MagiTypeWrapperProtocol {
    public let magiWrappedValue: T
    public init(value: T) {
        self.magiWrappedValue = value
    }
}

/// 命名空间协议
public protocol MagiNamespaceWrappable {
    associatedtype MagiWrappedType
    var magiPhotoBrowser: MagiWrappedType { get }
    static var magiPhotoBrowser: MagiWrappedType.Type { get }
}

extension MagiNamespaceWrappable {
    
    public var magiPhotoBrowser: MagiNamespaceWrapper<Self> {
        return MagiNamespaceWrapper(value: self)
    }
    
    public static var magiPhotoBrowser: MagiNamespaceWrapper<Self>.Type {
        return MagiNamespaceWrapper.self
    }
    
}
