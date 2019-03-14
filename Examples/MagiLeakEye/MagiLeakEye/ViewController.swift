//
//  ViewController.swift
//  MagiLeakEye
//
//  Created by anran on 2019/3/14.
//  Copyright © 2019 anran. All rights reserved.
//

import UIKit

class LeakTest: NSObject {
    
    var block: (() -> ())!
    
    init(block: @escaping () -> () ) {
        super.init()
        self.block = block
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        btn.setTitle("Push",
                     for: UIControl.State.normal)
        btn.setTitleColor(UIColor.red,
                          for: UIControl.State.normal)
        btn.addTarget(self,
                      action: #selector(pushToVC(sender:)),
                      for: UIControl.Event.touchUpInside)
        view.addSubview(btn)
    }

    @objc
    fileprivate func pushToVC(sender: UIButton) {
        navigationController?.pushViewController(SecondViewController(),
                                                      animated: true)
    }

}

class SecondViewController: UIViewController {
    
    private var str: String = ""
    private var test: LeakTest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton(frame: CGRect(x: 200, y: 100, width: 100, height: 100))
        btn.setTitle("Pop",
                     for: UIControl.State.normal)
        btn.setTitleColor(UIColor.red,
                          for: UIControl.State.normal)
        btn.addTarget(self,
                      action: #selector(popToVC(sender:)),
                      for: UIControl.Event.touchUpInside)
        self.view.addSubview(btn)
        self.test = LeakTest(block: {
            self.str = "安然"
        })
        view.backgroundColor = UIColor.white
        
    }
    
    @objc
    fileprivate func popToVC(sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("deinit")
    }
}

