//
//  QUButton.swift
//  FGP
//
//  Created by briceZhao on 2018/8/28.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit

enum QUButtonStyle {
    case horizontal
    case horizontalReverse
    case vertical
    case verticalReverse
    case unknown
}

class QUButton: UIButton {
    
    var titleSize: CGSize = CGSize.zero
    
    var layoutStyle: QUButtonStyle = .horizontal
    
    var margin: CGFloat = 5.0
    
    var titleRect: CGRect = CGRect.zero
    
    var imageRect: CGRect = CGRect.zero
    
    init(style: QUButtonStyle) {
        self.init()
        layoutStyle = style
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        if title != nil {
            titleSize = title!.getStringSize(text: title!, rectSize: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude), fontSize: 16)
        } else {
            titleSize = CGSize.zero
        }
    }
    
    override func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) {
        super.setAttributedTitle(title, for: state)
        if title != nil {
            titleSize = title!.boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size
        } else {
            titleSize = CGSize.zero
        }
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let tempTitleRect = super.titleRect(forContentRect: contentRect)
        var newTitleRect = tempTitleRect
        let tempImageRect = super.imageRect(forContentRect: contentRect)
        
        switch layoutStyle {
        case .horizontal:
            do {
            if tempImageRect == CGRect.zero {
                newTitleRect = tempTitleRect
            } else {
                newTitleRect = CGRect(x: tempImageRect.maxX + margin / 2.0, y: tempTitleRect.origin.y, width: tempTitleRect.width, height: tempTitleRect.height)
            }
        }
            break
            
        case .horizontalReverse:
            do {
                if tempImageRect == CGRect.zero {
                    newTitleRect = tempTitleRect
                } else {
                    newTitleRect = CGRect(x: tempImageRect.origin.x - margin / 2.0, y: tempTitleRect.origin.y, width: tempTitleRect.width, height: tempTitleRect.height)
                }
            }
            break
            
        case .vertical:
            do {
                if tempImageRect == CGRect.zero {
                    newTitleRect = tempTitleRect
                } else {
                    let imageY = contentRect.size.height/2.0 - (tempImageRect.size.height + margin + tempTitleRect.size.height)/2.0
                    let titleY = imageY + tempImageRect.size.height + margin/2.0
                    newTitleRect = CGRect(x: contentRect.width/2.0 - titleSize.width/2.0, y: titleY, width: titleSize.width, height: titleSize.height)
                }
            }
            break
            
        case .verticalReverse:
            do {
                if tempImageRect == CGRect.zero {
                    newTitleRect = tempTitleRect
                } else {
                    let titleY = contentRect.size.height/2.0 - (tempImageRect.size.height + margin + tempTitleRect.size.height)/2.0
                    newTitleRect = CGRect(x: contentRect.width/2.0 - titleSize.width/2.0, y: titleY, width: titleSize.width, height: titleSize.height)
                }
            }
            break
            
        case .unknown:
            newTitleRect = titleRect
            break
            
        }
        return newTitleRect
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        let tempImageRect = super.imageRect(forContentRect: contentRect)
        var newImageRect = tempImageRect
        let tempTitleRect = super.titleRect(forContentRect: contentRect)
        
        switch layoutStyle {
        case .horizontal:
            do {
                if tempTitleRect == CGRect.zero {
                    newImageRect = tempImageRect
                } else {
                    let imageHscale = tempTitleRect.height/tempImageRect.height
                    let imageH = tempTitleRect.height
                    let imageW = tempImageRect.width * imageHscale
                    newImageRect = CGRect(x: tempImageRect.origin.x - margin/2.0, y: tempImageRect.origin.y, width: imageW, height: imageH)
                }
            }
            break
            
        case .horizontalReverse:
            do {
                if tempImageRect == CGRect.zero {
                    newImageRect = tempImageRect
                } else {
                    let imageH = tempImageRect.height
                    let imageW = tempImageRect.width
                    newImageRect = CGRect(x: titleRect.maxX + margin / 2.0 - imageW, y: tempImageRect.origin.y, width: imageW, height: imageH)
                }
            }
            break
            
        case .vertical:
            do {
                if tempImageRect == CGRect.zero {
                    newImageRect = tempImageRect
                } else {
                    let imageY = contentRect.size.height/2.0 - (tempImageRect.size.height + margin + tempTitleRect.size.height)/2.0
                    newImageRect = CGRect(x: contentRect.width/2.0 - tempImageRect.width/2.0, y: imageY, width: tempImageRect.width, height: tempImageRect.height)
                }
            }
            break
            
        case .verticalReverse:
            do {
                if tempImageRect == CGRect.zero {
                    newImageRect = tempImageRect
                } else {
                    let titleY = contentRect.size.height/2.0 - (tempImageRect.size.height + margin + titleSize.height)/2.0
                    let imageY = titleY + titleSize.height + margin/2.0
                    newImageRect = CGRect(x: contentRect.width/2.0 - tempImageRect.width/2.0, y: imageY, width: tempImageRect.width, height: tempImageRect.height)
                }
            }
            break
            
        case .unknown:
            newImageRect = imageRect
            break
            
        }
        return newImageRect
    }
}
