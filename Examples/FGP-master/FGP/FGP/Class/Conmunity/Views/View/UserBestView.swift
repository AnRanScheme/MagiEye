//
//  UserBestView.swift
//  FGP
//
//  Created by 安然 on 2018/8/31.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class UserBestView: ASDisplayNode {
    
    var dataArray: [String] = [] {
        didSet {
            setupUI()
            transitionLayout(withAnimation: true,
                             shouldMeasureAsync: false,
                             measurementCompletion: nil)
        }
    }
    
    fileprivate var userNodes: [ASTextNode2] = []

    override init() {
        super.init()
        setupUI()
        isUserInteractionEnabled = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let commitSpec = ASStackLayoutSpec.horizontal()
        commitSpec.justifyContent = .spaceBetween
        commitSpec.spacing = 8
        commitSpec.style.flexGrow = 1
        commitSpec.style.flexShrink = 1
        commitSpec.flexWrap = .wrap
        commitSpec.children = userNodes
        userNodes.forEach {
            $0.style.flexGrow = 1
            $0.style.flexShrink = 1
        }
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8),
                                 child: commitSpec)
    }
    
}

extension UserBestView {
    
    fileprivate func setupUI() {
        backgroundColor = UIColor(hex: 0xe1e1e1)
        userNodes.removeAll()
        subnodes?.forEach({ (node) in
            node.removeFromSupernode()
        })
        dataArray.enumerated().forEach({ (objc) in
            let userNode = ASTextNode2()
            userNode.attributedText = NSAttributedString(
                string: objc.element,
                attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                             NSAttributedString.Key.foregroundColor: UIColor.orange,
                             NSAttributedString.Key.link: objc.element,
                             NSAttributedString.Key.underlineColor: UIColor.clear])
            userNode.delegate = self
            userNode.isUserInteractionEnabled = true
            addSubnode(userNode)
            userNodes.append(userNode)
        })
    }
    
}

extension UserBestView: ASTextNodeDelegate {
    
    func textNode(_ textNode: ASTextNode!, tappedLinkAttribute attribute: String!, value: Any!, at point: CGPoint, textRange: NSRange) {
        print("attribute------\(String(describing: attribute))")
        print("textNode------\(String(describing: textNode.attributedText))")
        print("value------\(String(describing: value))")
    }
    
}


