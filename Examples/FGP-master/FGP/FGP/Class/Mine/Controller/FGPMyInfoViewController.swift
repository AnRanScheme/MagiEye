//
//  FGPMyInfoViewController.swift
//  FGP
//
//  Created by briceZhao on 2018/8/29.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit

class FGPMyInfoViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.titleLabel.text = "个人详情"
        navigationBar.leftBarButton.setImage(#imageLiteral(resourceName: "nav_back2.png"), for: .normal)
        navigationBar.leftBarButton.addTarget(self, action: #selector(self.goBackButtonClick), for: UIControl.Event.touchUpInside)
    }
    
    @objc func goBackButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
