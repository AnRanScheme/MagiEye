//
//  MainTabBarViewController.swift
//  FGP
//
//  Created by briceZhao on 2018/8/26.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit
import MagiTabBarController

class MainTabBarViewController: MagiTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureChildViewControllerFiles()
    }
    
    private func configureChildViewControllerFiles () {
        
        guard let jsonPath = Bundle.main.path(forResource: "MainTabBarFile.json", ofType: nil) else { return  }
        
        guard let jsonData = NSData.init(contentsOfFile: jsonPath) else { return  }
        
        guard let json = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) else { return  }
        
        let anyObject = json as AnyObject
        
        guard let dict = anyObject as? [String: Any] else { return }
        
        guard let dictArray = dict["tabbar_items"] as? [[String : Any]] else { return }
        
        for dict in dictArray {
            
            guard let vcName = dict["page"] as? String else { continue }
            guard let title = dict["title"] as? String else { continue }
            guard let imageName = dict["normal_icon"] as? String else { continue }
            
            setupChildViewControllers(vcName: vcName,
                                      title: title,
                                      imageName: imageName)
            
        }
    }
    
    private func setupChildViewControllers(vcName: String, title: String, imageName: String) {
        
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let clsName = namespace + "." + vcName
        let cls = NSClassFromString(clsName) as! UIViewController.Type
        let vc = cls.init()
        vc.tabBarItem = MagiTabBarItem(
            TabBarAnimate(),
            title: title,
            image: UIImage(named: imageName),
            selectedImage: UIImage(named: "\(imageName)_selected")?.withRenderingMode(.alwaysOriginal))
        vc.title = title
        let navVC = BaseNavigationController(rootViewController: vc)
        viewControllers?.append(navVC)
        addChild(navVC)
    }

}

class TabBarAnimate: MagiTabBarItemContentView {
    
    public var duration = 0.3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor(white: 175.0 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor.orange
        iconColor = UIColor(white: 175.0 / 255.0, alpha: 1.0)
        highlightIconColor = UIColor.orange
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        bounceAnimation()
        completion?()
    }
    
    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        bounceAnimation()
        completion?()
    }
    
    func bounceAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
    
}
