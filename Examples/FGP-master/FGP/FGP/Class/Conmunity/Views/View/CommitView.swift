//
//  CommitView.swift
//  FGP
//
//  Created by anran on 2018/8/27.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CommitView: ASDisplayNode {
    
    var dataArray: [String] = [] {
        didSet {
            setupUI()
            transitionLayout(withAnimation: true,
                             shouldMeasureAsync: false,
                             measurementCompletion: nil)
        }
    }
    
    fileprivate var titleNode: [CommitViewItem] = []
    
    override init() {
        super.init()
        setupUI()
        isUserInteractionEnabled = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let commitSpec = ASStackLayoutSpec.vertical()
        commitSpec.justifyContent = .spaceBetween
        commitSpec.spacing = 8
        commitSpec.style.flexGrow = 1
        commitSpec.style.flexShrink = 1
        commitSpec.children = titleNode
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0),
                                 child: commitSpec)
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        guard let toNode = context.insertedSubnodes().first else { return }
        let toNodeFrame = context.finalFrame(for: toNode)
        toNode.frame = toNodeFrame
        toNode.alpha = 0.0
        
        UIView.animate(withDuration: defaultLayoutTransitionDuration,
                       animations: {
                        toNode.frame = context.finalFrame(for: toNode)
                        toNode.alpha = 1.0
        },
                       completion: { (isFinished) in
                        context.completeTransition(isFinished)
        })
    }

}

// MARK: - 自定义方法
extension CommitView {
    
    fileprivate func setupUI() {
        backgroundColor = UIColor(hex: 0xe1e1e1)
        titleNode.removeAll()
        subnodes?.forEach({ (node) in
            node.removeFromSupernode()
        })
        dataArray.enumerated().forEach({ (objc) in
            let dict = ["name": "安然\(objc.offset)",
                "content": objc.element]
            let titleLabel = CommitViewItem(dict)
            addSubnode(titleLabel)
            titleNode.append(titleLabel)
        })
    }
    
    func addComment(_ para: String) {
        //dataArray.insert(para, at: 0)
        let dict = ["name": "添加的用户",
                    "content": para]
        let titleLabel = CommitViewItem(dict)
        addSubnode(titleLabel)
        titleNode.insert(titleLabel, at: 0)
        transitionLayout(withAnimation: false,
                         shouldMeasureAsync: false,
                         measurementCompletion: nil)
    }
    
}
