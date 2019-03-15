//
//  AppSwizzle.swift
//  MagiNetworkEye
//
//  Created by anran on 2019/3/12.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation
import ObjectiveC


public enum SwizzleResult {
    case succeed
    case originMethodNotFound
    case alternateMethodNotFound
}

public extension NSObject {
    
    public class func swizzleInstanceMethod(origSelector: Selector,
                                            toAlterSelector alterSelector: Selector) -> SwizzleResult {
        return swizzleMethod(
            origSelector: origSelector,
            toAlterSelector: alterSelector,
            inAlterClass: self.classForCoder(),
            isClassMethod: false)
    }
    
    public class func swizzleClassMethod(origSelector: Selector,
                                         toAlterSelector alterSelector: Selector) -> SwizzleResult {
        return swizzleMethod(
            origSelector: origSelector,
            toAlterSelector: alterSelector,
            inAlterClass: self.classForCoder(),
            isClassMethod: true)
    }
    
    
    public class func swizzleInstanceMethod(origSelector: Selector,
                                            toAlterSelector alterSelector: Selector,
                                            inAlterClass alterClass: AnyClass) -> SwizzleResult {
        return swizzleMethod(
            origSelector: origSelector,
            toAlterSelector: alterSelector,
            inAlterClass: alterClass,
            isClassMethod: false)
    }
    
    public class func swizzleClassMethod(origSelector: Selector,
                                         toAlterSelector alterSelector: Selector,
                                         inAlterClass alterClass: AnyClass) -> SwizzleResult {
        return swizzleMethod(
            origSelector: origSelector,
            toAlterSelector: alterSelector,
            inAlterClass: alterClass,
            isClassMethod: true)
    }
    
    
    private class func swizzleMethod(origSelector: Selector,
                                     toAlterSelector alterSelector: Selector,
                                     inAlterClass alterClass: AnyClass,
                                     isClassMethod: Bool) -> SwizzleResult {
        
        var alterClass: AnyClass? = alterClass
        var origClass: AnyClass = self.classForCoder()
        if isClassMethod {
            alterClass = object_getClass(alterClass)
            guard let _class = object_getClass(self.classForCoder()) else {
                return .originMethodNotFound
            }
            origClass = _class
        }
        
        return SwizzleMethod(
            origClass: origClass,
            origSelector: origSelector,
            toAlterSelector: alterSelector,
            inAlterClass: alterClass)
    }
}


private func SwizzleMethod(origClass: AnyClass,
                           origSelector: Selector,
                           toAlterSelector alterSelector: Selector,
                           inAlterClass alterClass: AnyClass?) -> SwizzleResult{
    
    guard  let origMethod: Method = class_getInstanceMethod(origClass, origSelector) else {
        return SwizzleResult.originMethodNotFound
    }
    
    guard let altMethod: Method = class_getInstanceMethod(alterClass, alterSelector) else {
        return SwizzleResult.alternateMethodNotFound
    }
    
    _ = class_addMethod(origClass,
                        origSelector,
                        method_getImplementation(origMethod),
                        method_getTypeEncoding(origMethod))
    
    
    _ = class_addMethod(alterClass,
                        alterSelector,
                        method_getImplementation(altMethod),
                        method_getTypeEncoding(altMethod))
    
    method_exchangeImplementations(origMethod, altMethod)
    
    return SwizzleResult.succeed
    
}

struct MagiRunTime {
    
    /// 交换方法
    /// - Parameters:
    ///   - selector: 被交换的方法
    ///   - replace: 用于交换的方法
    ///   - classType: 所属类型
    static func exchangeMethod(selector: Selector,
                               replace: Selector,
                               class classType: AnyClass) {
        let select1 = selector
        let select2 = replace
        let select1Method = class_getInstanceMethod(classType, select1)
        let select2Method = class_getInstanceMethod(classType, select2)
        guard let selectMetho1 = select1Method,
            let selectMethod2 = select2Method else {
                return
        }
        let didAddMethod  = class_addMethod(classType,
                                            select1,
                                            method_getImplementation(selectMethod2),
                                            method_getTypeEncoding(selectMethod2))
        if didAddMethod {
            class_replaceMethod(classType,
                                select2,
                                method_getImplementation(selectMetho1),
                                method_getTypeEncoding(selectMetho1))
        } else {
            method_exchangeImplementations(selectMetho1, selectMethod2)
        }
    }
    
    /// 获取方法列表
    ///
    /// - Parameter classType: 所属类型
    /// - Returns: 方法列表
    static func methods(from classType: AnyClass) -> [Method] {
        var methodNum: UInt32 = 0
        var list = [Method]()
        let methods = class_copyMethodList(classType, &methodNum)
        for index in 0..<numericCast(methodNum) {
            if let met = methods?[index] {
                list.append(met)
            }
        }
        free(methods)
        return list
    }
    
    /// 获取属性列表
    ///
    /// - Parameter classType: 所属类型
    /// - Returns: 属性列表
    static func properties(from classType: AnyClass) -> [objc_property_t] {
        var propNum: UInt32 = 0
        let properties = class_copyPropertyList(classType, &propNum)
        var list = [objc_property_t]()
        for index in 0..<Int(propNum) {
            if let prop = properties?[index]{
                list.append(prop)
            }
        }
        free(properties)
        return list
    }
    
    
    /// 成员变量列表
    ///
    /// - Parameter classType: 类型
    /// - Returns: 成员变量
    static func ivars(from classType: AnyClass) -> [Ivar] {
        var ivarNum: UInt32 = 0
        let ivars = class_copyIvarList(classType, &ivarNum)
        var list = [Ivar]()
        for index in 0..<numericCast(ivarNum) {
            if let ivar: objc_property_t = ivars?[index] {
                list.append(ivar)
            }
        }
        free(ivars)
        return list
    }
    
}
