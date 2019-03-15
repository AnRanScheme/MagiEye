//
//  MagiEyeController.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation
import UIKit

class MagiEyeController: UITabBarController {
    
    static let shared = MagiEyeController()
    
    var configuration: Configuration? {
        didSet {
            /// because the `viewControllers` will use configuration,
            /// but `GodEyeController.shared.configuration` will call
            /// `viewDidLoad` first,then call the `didSet`
            viewControllers = [consoleVC,
                               monitorVC,
                               fileVC,
                               settingVC]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        selectedIndex = 0
        tabBar.barTintColor = UIColor.black
    }
    
    lazy var consoleVC: UINavigationController = {
        let new = UINavigationController(rootViewController: ConsoleController())
        new.tabBarItem = UITabBarItem(title: "Console", image: nil, selectedImage: nil)
        new.isNavigationBarHidden = true
        new.hidesBottomBarWhenPushed = true
        return new
    }()
    
    lazy var monitorVC: UINavigationController = {
        let new = UINavigationController(rootViewController: MonitorController())
        new.tabBarItem = UITabBarItem(title: "Monitor", image: nil, selectedImage: nil)
        new.isNavigationBarHidden = true
        new.hidesBottomBarWhenPushed = true
        return new
    }()
    
    lazy var fileVC: UINavigationController = {
        let new = UINavigationController(rootViewController: FileController())  //FileBrowser(initialPath: url!)
        new.tabBarItem = UITabBarItem(title: "File", image: nil, selectedImage: nil)
        new.isNavigationBarHidden = true
        new.hidesBottomBarWhenPushed = true
        return new
    }()
    
    lazy var settingVC: UINavigationController = {
        let new = UINavigationController(rootViewController: SettingController())
        new.tabBarItem = UITabBarItem(title: "Setting", image: nil, selectedImage: nil)
        new.isNavigationBarHidden = true
        new.hidesBottomBarWhenPushed = true
        return new
    }()
}
