//
//  FGPMineViewController.swift
//  FGP
//
//  Created by briceZhao on 2018/8/26.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit

class FGPMineViewController: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    lazy var mineTableView: UITableView = {
        let table = UITableView()
        
        return table
    }()
    
    lazy var profileView: FGPMineProfileView = {
        let view = FGPMineProfileView(frame: CGRect(x: 0, y: kTopLayoutHeight-15, width: kScreenW, height: 320))
        view.addSubview(view.iconImageView)
        view.iconImageView.image = #imageLiteral(resourceName: "item_head.jpg")
        view.addSubview(view.usernameLabel)
        view.usernameLabel.text = "顾晓曼"
        view.addSubview(view.ageLabel)
        view.ageLabel.text = "22岁"
        view.addSubview(view.sexImageView)
        view.sexImageView.image = #imageLiteral(resourceName: "icon_female.png")
        view.addSubview(view.contentLabel)
        view.contentLabel.text = "只要你足够优秀，你想要的都会拥有"
        view.addSubview(view.myInfoButton)
        view.myInfoButton.setTitle("我的信息", for: .normal)
        view.myInfoButton.setImage(#imageLiteral(resourceName: "tabbar_home.png"), for: .normal)
        view.myInfoButton.addTarget(self, action: #selector(gotoMyInfoViewController), for: UIControl.Event.touchUpInside)
        view.addSubview(view.identityButton)
        view.identityButton.setTitle("实名认证", for: .normal)
        view.identityButton.setImage(#imageLiteral(resourceName: "tabbar_profile.png"), for: .normal)
        return view
    }()
    
    @objc func gotoMyInfoViewController() {
        let info = FGPMyInfoViewController()
        self.navigationController?.pushViewController(info, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.rightBarButton.setImage(#imageLiteral(resourceName: "nav_setting.png"), for: .normal)
        
        view.addSubview(profileView)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}

