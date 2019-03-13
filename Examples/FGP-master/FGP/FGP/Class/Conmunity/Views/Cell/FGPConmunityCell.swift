//
//  FGPConmunityCell.swift
//  FGP
//
//  Created by anran on 2018/8/27.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol FGPConmunityCellDelegate: class {
    func conmunityCell(_ cell: FGPConmunityCell,
                       model: FGPCommunotyModel,
                       type: FGPConmunityCell.FGPConmunityCellDelegateType,
                       nodeAt indexPath: IndexPath)
    
    func conmunityCell(_ cell: FGPConmunityCell,
                       photoNote: ASNetworkImageNode,
                       selectImage: String,
                       nodeAt indexPath: IndexPath)
}

class FGPConmunityCell: ASCellNode {
    
    enum FGPConmunityCellDelegateType {
        case comment
        case shared
        case best
    }
    
    fileprivate lazy var titleLabel: ASTextNode = {
        let titleLabel = ASTextNode()
        titleLabel.maximumNumberOfLines = 1
        
        return titleLabel
    }()
    
    fileprivate lazy var timeLabel: ASTextNode = {
        let timeLabel = ASTextNode()
        timeLabel.maximumNumberOfLines = 1
        
        return timeLabel
    }()
    
    fileprivate lazy var contentLabel: ASTextNode = {
        let contentLabel = ASTextNode()
        contentLabel.maximumNumberOfLines = 2
        contentLabel.truncationMode = .byTruncatingTail
        
        return contentLabel
    }()
    
    fileprivate lazy var contentLabel1: ASTextNode = {
        let contentLabel = ASTextNode()
        contentLabel.maximumNumberOfLines = 0
        contentLabel.truncationMode = .byTruncatingTail
        
        return contentLabel
    }()
    
    fileprivate lazy var photoNode: ASNetworkImageNode = {
        let photoNode = ASNetworkImageNode()
        photoNode.defaultImage = UIImage(named: "tabbar_home_selected")
        photoNode.contentMode = .scaleAspectFill
        photoNode.cornerRadius = 5
        photoNode.addTarget(self,
                            action: #selector(photoNodeAction(_:)),
                            forControlEvents: .touchUpInside)
        
        return photoNode
    }()
    
    fileprivate lazy var bestBtn: ASButtonNode = {
        let btn = ASButtonNode()
        btn.setImage(UIImage(named: "conmunity_best_normal"),
                     for: .normal)
        btn.setImage(UIImage(named: "conmunity_best_selected"),
                     for: .selected)
        btn.addTarget(self,
                      action: #selector(bestBtnAction(_:)),
                      forControlEvents: .touchUpInside)
        
        return btn
    }()
    
    fileprivate lazy var commitBtn: ASButtonNode = {
        let btn = ASButtonNode()
        btn.setImage(UIImage(named: "conmunity_commit_normal"),
                     for: .normal)
        btn.setImage(UIImage(named: "conmunity_commit_selected"),
                     for: .selected)
        btn.addTarget(self,
                      action: #selector(commitBtnAction(_:)),
                      forControlEvents: .touchUpInside)
        
        return btn
    }()
    
    fileprivate lazy var sharedBtn: ASButtonNode = {
        let btn = ASButtonNode()
        btn.setImage(UIImage(named: "conmunity_shared_normal"),
                     for: .normal)
        btn.setImage(UIImage(named: "conmunity_shared_selected"),
                     for: .selected)
        btn.addTarget(self,
                      action: #selector(sharedBtnAction(_:)),
                      forControlEvents: .touchUpInside)
        
        return btn
    }()
    
    
    fileprivate lazy var userBestView: UserBestView = {
        let userBestView = UserBestView()
        
        return userBestView
    }()
    
    fileprivate lazy var commitView: CommitView = {
        let commitView = CommitView()
        
        return commitView
    }()
    
    var isShow: Bool = false
    weak var delegate: FGPConmunityCellDelegate?
    var indexPaths: IndexPath?
    var model: FGPCommunotyModel? {
        didSet {
            if let title = model?.title {
                let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 17),
                                                            .foregroundColor: UIColor.black]
                let attributedText  = NSAttributedString(string: title,
                                                         attributes: attrs)
                
                titleLabel.attributedText = attributedText
            }
            
            if let subTitle = model?.time {
                let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14),
                                                           .foregroundColor: UIColor(hex: 0x999999)]
                let attributedText  = NSAttributedString(string: subTitle,
                                                         attributes: attrs)
                timeLabel.attributedText = attributedText
            }
            
            
            if let content = model?.content {
                let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16),
                                                            .foregroundColor: UIColor(hex: 0x333333)]
                let attributedText  = NSAttributedString(string: content,
                                                         attributes: attrs)
                contentLabel.attributedText = attributedText
                contentLabel1.attributedText = attributedText
            }
            
            
            if let imageString = model?.photoImageString {
                let url = URL(string: imageString)
                photoNode.setURL(url, resetToDefault: true)
            }
            
            if let array = model?.userComment {
                commitView.dataArray = array
                userBestView.dataArray = array
            }
            
        }
    }
    
    
    override init() {
        super.init()
        setupUI()
        isUserInteractionEnabled = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let content = isShow ? contentLabel1  : contentLabel
        
        let headerStack = ASStackLayoutSpec.vertical()
        headerStack.style.flexGrow = 1.0
        headerStack.style.flexShrink = 1.0
        headerStack.spacing = 8
        headerStack.children = [titleLabel,
                                timeLabel,
                                content]
        
        let photoDimension: CGFloat = constrainedSize.max.width - 24
        photoNode.style.preferredSize = CGSize(width: photoDimension, height: photoDimension*9/16)

        let btnStack = ASStackLayoutSpec.horizontal()
        btnStack.spacing = 30
        btnStack.justifyContent = .start
        btnStack.children = [bestBtn,
                             commitBtn,
                             sharedBtn]
        
        let commitStack = ASStackLayoutSpec.vertical()
        commitStack.spacing = 0
        commitStack.justifyContent = .start
        commitStack.children = [userBestView,
                                commitView]
        
        
        let photoStack = ASStackLayoutSpec.vertical()
        photoStack.spacing = 10
        photoStack.justifyContent = .spaceBetween
        photoStack.children = [headerStack,
                               photoNode,
                               btnStack,
                               commitStack]
        
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 8,
                                 left: 12,
                                 bottom: 8,
                                 right: 12),
            child: photoStack)
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        guard let fromNode = context.removedSubnodes().first else { return }
        guard let toNode = context.insertedSubnodes().first else { return }
        
        let toNodeFrame = context.finalFrame(for: toNode)
        toNode.frame = toNodeFrame
        toNode.alpha = 0.0
        
        let fromNodeFrame = fromNode.frame
    
        UIView.animate(
            withDuration: defaultLayoutTransitionDuration,
            animations: {
                toNode.frame = context.finalFrame(for: toNode)
                toNode.alpha = 1.0
                fromNode.frame = fromNodeFrame
                fromNode.alpha = 0.0
                self.photoNode.frame = context.finalFrame(for: self.photoNode)
                self.commitView.frame = context.finalFrame(for: self.commitView)
                self.sharedBtn.frame = context.finalFrame(for: self.sharedBtn)
                self.bestBtn.frame = context.finalFrame(for: self.bestBtn)
                self.userBestView.frame = context.finalFrame(for: self.userBestView)
                self.commitBtn.frame = context.finalFrame(for: self.commitBtn)
        }) { (finished) in
            context.completeTransition(finished)
        }
        
    }

}

// MARK: - 自定义方法
extension FGPConmunityCell {
    
    fileprivate func setupUI() {
        automaticallyManagesSubnodes = true
        backgroundColor = UIColor.white
        selectionStyle = .none
    }
    
}

// MARK: - Action
extension FGPConmunityCell {
    
    @objc
    fileprivate func bestBtnAction(_ sender: ASButtonNode) {
        sender.isSelected = !sender.isSelected
        guard let data = model else { return }
        guard let index = indexPath else { return }
        delegate?.conmunityCell(self,
                                model: data,
                                type: .best,
                                nodeAt: index)
        commitView.addComment("添加了评论")
        transitionLayout(withAnimation: true,
                         shouldMeasureAsync: false,
                         measurementCompletion: nil)
    }
    
    @objc
    fileprivate func commitBtnAction(_ sender: ASButtonNode) {
        sender.isSelected = !sender.isSelected
        guard let data = model else { return }
        guard let index = indexPath else { return }
        if sender.isSelected {
             if let array = model?.userComment {
                commitView.dataArray = array
            }
        }
        
        else {
            commitView.dataArray = ["修改评论",
                                    """
Facebook出得这个AsyncDisplayKit严格意义上讲，已经远远超出了超出了AsyncDispl
            ay的范围. 我个人在最开始思考AsyncDisplay的时候，以为这只是一个解决异步渲染的问题，可能是最大限度的在l
            ayer层display的时候做文章，直到我粗略了学习了下他的源码，才发现，我只看到了ASDK中
"""]
        }
        transitionLayout(withAnimation: true,
                         shouldMeasureAsync: false,
                         measurementCompletion: nil)
        delegate?.conmunityCell(self,
                                model: data,
                                type: .comment,
                                nodeAt: index)
    }
    
    @objc
    fileprivate func sharedBtnAction(_ sender: ASButtonNode) {
        sender.isSelected = !sender.isSelected
        isShow = !isShow
        guard let data = model else { return }
        guard let index = indexPath else { return }
        delegate?.conmunityCell(self,
                                model: data,
                                type: .shared,
                                nodeAt: index)
        transitionLayout(withAnimation: true,
                              shouldMeasureAsync: false,
                              measurementCompletion: nil)
    }
    
    @objc
    fileprivate func photoNodeAction(_ sender: ASNetworkImageNode) {
        guard let index = indexPath else { return }
        self.delegate?.conmunityCell(self, photoNote: self.photoNode, selectImage: "米好", nodeAt: index)
    }
    
}
