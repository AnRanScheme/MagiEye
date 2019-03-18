//
//  MagiEyeController.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation
import UIKit

/// MagiEyeTabBarController
class MagiEyeController: UITabBarController {
    
    static let shared = MagiEyeController()
    
    //MARK: - Property
    lazy var consoleVC: UINavigationController = {
        let new = UINavigationController(
            rootViewController: ConsoleController())
        new.tabBarItem = UITabBarItem(title: "Console", image: nil, selectedImage: nil)
        new.isNavigationBarHidden = true
        new.hidesBottomBarWhenPushed = true
        
        return new
    }()
    
    lazy var monitorVC: UINavigationController = {
        let new = UINavigationController(
            rootViewController: MonitorController())
        new.tabBarItem = UITabBarItem(title: "Monitor", image: nil, selectedImage: nil)
        new.isNavigationBarHidden = true
        new.hidesBottomBarWhenPushed = true
        
        return new
    }()
    
    lazy var fileVC: UINavigationController = {
        let new = UINavigationController(
            rootViewController: FileController())
        new.tabBarItem = UITabBarItem(title: "File",
                                      image: nil,
                                      selectedImage: nil)
        new.isNavigationBarHidden = true
        new.hidesBottomBarWhenPushed = true
        
        return new
    }()
    
    lazy var settingVC: UINavigationController = {
        let new = UINavigationController(
            rootViewController: SettingController())
        new.tabBarItem = UITabBarItem(title: "Setting",
                                      image: nil,
                                      selectedImage: nil)
        new.isNavigationBarHidden = true
        new.hidesBottomBarWhenPushed = true
        
        return new
    }()
    /*
     because the `viewControllers` will use configuration,
     but `MagiEyeController.shared.configuration` will call
     `viewDidLoad` first,then call the `didSet`
     */
    var configuration: Configuration? {
        didSet {
            viewControllers = [consoleVC,
                               monitorVC,
                               fileVC,
                               settingVC]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 0
        tabBar.barTintColor = UIColor.black
        view.backgroundColor = UIColor.black
    }

}
