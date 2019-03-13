//
//  CommitViewCell.swift
//  FGP
//
//  Created by anran on 2018/8/28.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CommitViewItem: ASDisplayNode {
    
    fileprivate lazy var contentNode: ASTextNode = {
        let contentNode = ASTextNode()
        let content = (dict?["name"] ?? "")+" : "+(dict?["content"] ?? "")
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14),
                                                   .foregroundColor: UIColor(hex: 0x999999)]
        let attributedText = NSMutableAttributedString(
            string: content,
            attributes: attrs)
        let range = (content as NSString).range(of: dict?["name"] ?? "",
                                                options: .regularExpression,
                                                range: NSMakeRange(0,content.count))
        attributedText.addAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.orange,
             NSAttributedString.Key.link: dict?["name"] ?? "",
             NSAttributedString.Key.underlineColor: UIColor.clear],
            range: (content as NSString).range(of: dict?["name"] ?? ""))
        contentNode.delegate = self
        contentNode.isUserInteractionEnabled = true
        contentNode.truncationMode = .byTruncatingTail

        contentNode.attributedText = attributedText
     
        return contentNode
    }()
    
    var dict: [String: String]?
    
    fileprivate var dataClosure: (([String: String])->())?
    
    convenience init(_ para: [String: String]) {
        self.init()
        self.dict = para
        isUserInteractionEnabled = true
    }
    
    override init() {
        super.init()
        backgroundColor = UIColor(hex: 0xe1e1e1)
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let backSpec = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 0,
                                 left: 8,
                                 bottom: 0,
                                 right: 8),
            child: contentNode)

        return backSpec
    }

}

extension CommitViewItem: ASTextNodeDelegate {
    
    func textNode(_ textNode: ASTextNode!, tappedLinkAttribute attribute: String!, value: Any!, at point: CGPoint, textRange: NSRange) {
        print("attribute------\(String(describing: attribute))")
        print("textNode------\(String(describing: textNode.attributedText))")
        print("value------\(String(describing: value))")
        if let para = dict {
            dataClosure?(para)
        }
    }
    
}

extension CommitViewItem {
    
    func didClickUser(complection: (([String: String])->())?) {
        self.dataClosure = complection
    }
    
}

