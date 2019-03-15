//
//  Variable.swift
//  MagiLeakEye
//
//  Created by anran on 2019/3/14.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation


// MARK: - Variable
// DESCRIPTION: light wrap of the property of runtime
class Variable: NSObject {
    // MARK: PRIVATE PROPERTY
    fileprivate var property: objc_property_t
    
    init(property: objc_property_t) {
        self.property = property
        super.init()
    }
    
    // MARK: INTERNAL FUNCTION
    /// is a strong property
    func isStrong() -> Bool {
        guard let property_getAttributes = property_getAttributes(property)
            else { return false }
        let attr = String(cString: property_getAttributes)
        return attr.contains("&")
    }
    
    /// name of the property
    func name() -> String {
        return String(cString: property_getName(property))
    }
    
    /// type of the property
    func type() -> AnyClass? {
        guard let property_getAttributes = property_getAttributes(property)
            else { return nil }
        let t = String(cString: property_getAttributes).components(separatedBy: ",").first
        guard let type = t?.between(left: "@\"", right: "\"") else {
            return nil
        }
        return NSClassFromString(type)
    }
    

}
