//
//  BaseViewController.swift
//  FGP
//
//  Created by briceZhao on 2018/8/27.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var navigationBar: BaseNavigationBar = {
        let navbar = BaseNavigationBar(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kTopLayoutHeight))
        navbar.backgroundColor = UIColor.orange
        return navbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(navigationBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
