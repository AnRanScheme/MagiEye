//
//  FGPMineProfileView.swift
//  FGP
//
//  Created by briceZhao on 2018/8/26.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit

class FGPMineProfileView: UIView {
    
    lazy var iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.frame = CGRect(x: kScreenW/2.0 - 45.0, y: 0, width: 90.0, height: 90.0)
        icon.layer.cornerRadius = 45.0
        icon.layer.masksToBounds = true
        return icon
    }()
    
    lazy var usernameLabel: UILabel = {
        let name = UILabel()
        name.frame = CGRect(x: kScreenW/2.0 - 55, y: 120, width: 55, height: 20)
        name.textColor = UIColor(hex: 0x333333)
        name.font = UIFont.systemFont(ofSize: 17)
        return name
    }()
    
    lazy var ageLabel: UILabel = {
        let age = UILabel()
        age.frame = CGRect(x: kScreenW/2.0, y: 120, width: 35, height: 20)
        age.textColor = UIColor(hex: 0x666666)
        age.font = UIFont.systemFont(ofSize: 15)
        return age
    }()
    
    lazy var sexImageView: UIImageView = {
        let sex = UIImageView()
        sex.frame = CGRect(x: kScreenW/2.0 + 35, y: 123, width: 14, height: 14)
        sex.contentMode = UIView.ContentMode.scaleAspectFit
        return sex
    }()
    
    lazy var contentLabel: UILabel = {
        let content = UILabel()
        content.frame = CGRect(x: 0, y: 145, width: kScreenW, height: 25)
        content.textColor = UIColor(hex: 0xBBBBBB)
        content.textAlignment = NSTextAlignment.center
        content.font = UIFont.systemFont(ofSize: 12)
        return content
    }()
    
    lazy var myInfoButton: QUButton = {
        let info = QUButton(style: .vertical)
        info.frame = CGRect(x: 10, y: 170, width: (kScreenW - 40)/3.0, height: 80)
        info.setTitleColor(UIColor(hex: 0xBBBBBB), for: .normal)
        info.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return info
    }()
    
    lazy var identityButton: QUButton = {
        let identity = QUButton(style: .vertical)
        identity.frame = CGRect(x: 10+(kScreenW - 40)/3.0+10, y: 170, width: (kScreenW - 40)/3.0, height: 80)
        identity.setTitleColor(UIColor(hex: 0xBBBBBB), for: .normal)
        identity.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return identity
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
