//
//  BaseNavigationBar.swift
//  FGP
//
//  Created by briceZhao on 2018/8/27.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit

class BaseNavigationBar: UIView {

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect(x: 80, y: kTopLayoutHeight-kNavbarHeight, width: kScreenW-160, height: kNavbarHeight))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor.white
        return titleLabel
    }()
    
    lazy var rightBarButton: BaseBarButton = {
        let right = BaseBarButton(frame: CGRect(x: kScreenW-70, y: kTopLayoutHeight-kNavbarHeight, width: 60, height: kNavbarHeight))
        right.setTitleColor(UIColor.white, for: .normal)
        right.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return right
    }()
    
    lazy var leftBarButton: BaseBarButton = {
        let left = BaseBarButton(frame: CGRect(x: 10, y: kTopLayoutHeight-kNavbarHeight, width: 60, height: kNavbarHeight))
        left.setTitleColor(UIColor.white, for: .normal)
        left.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return left
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(leftBarButton)
        addSubview(titleLabel)
        addSubview(rightBarButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
