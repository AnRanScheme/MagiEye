//
//  FGPPublishViewController.swift
//  FGP
//
//  Created by anran on 2018/10/25.
//  Copyright © 2018 BriceZhao. All rights reserved.
//

import UIKit

class FGPPublishViewController: UIViewController {
    
    lazy var btn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 80, height: 40))
        btn.setTitle(" 点我弹出图片" ,
                     for: UIControl.State.normal)
        btn.addTarget(self,
                      action: #selector(btnAction(_:)),
                      for: UIControl.Event.touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - Custom
extension FGPPublishViewController {
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
    }
    
}

// MARK: - LoadData
extension FGPPublishViewController {
    
}

// MARK: - Action
extension FGPPublishViewController {
    
    @objc
    fileprivate func btnAction(_ sender: UIButton) {
        
    }
    
}
