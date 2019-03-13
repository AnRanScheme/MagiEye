//
//  UIView+Extension.swift
//  FGP
//
//  Created by 安然 on 2018/8/26.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit

extension UIView{
    
    var x: CGFloat{
        get{
            return self.frame.origin.x
        }
        
        set{
            self.frame.origin.x = newValue
        }
    }
    
    var y: CGFloat{
        get{
            return self.frame.origin.y
        }
        
        set{
            self.frame.origin.y = newValue
        }
    }
    
    var width: CGFloat{
        get{
            return self.frame.size.width
        }
        
        set{
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat{
        get{
            return self.frame.size.height
        }
        
        set{
            self.frame.size.height = newValue
        }
    }
    
    var size: CGSize{
        get{
            return self.frame.size
        }
        
        set{
            self.frame.size = newValue
        }
    }
    
    var centerX: CGFloat{
        get{
            return self.center.x
        }
        
        set {
            self.center.x = newValue
        }
    }
    
    var centerY: CGFloat{
        get{
            return self.center.y
        }
        
        set{
            self.center.y = newValue
        }
    }
    
    // 关联 SB 和 XIB
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable public var shadowColor: UIColor? {
        get {
            return layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) : nil
        }
        
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable public var zPosition: CGFloat {
        get {
            return layer.zPosition
        }
        
        set {
            layer.zPosition = newValue
        }
    }
    
}

