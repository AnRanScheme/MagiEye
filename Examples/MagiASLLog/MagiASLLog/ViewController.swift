//
//  ViewController.swift
//  MagiASLLog
//
//  Created by anran on 2019/3/7.
//  Copyright © 2019 anran. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MagiLogDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        btn.backgroundColor = UIColor.yellow
        btn.setTitle("Present", for: .normal)
        btn.addTarget(self, action: #selector(ViewController.presentViewController2), for: .touchUpInside)
        self.view.addSubview(btn)
        
        let btn2 = UIButton(frame: CGRect(x: 100, y: 250, width: 100, height: 100))
        btn2.backgroundColor = UIColor.red
        btn2.setTitle("LOG", for: .normal)
        btn2.addTarget(self, action: #selector(ViewController.log), for: .touchUpInside)
        self.view.addSubview(btn2)

        
        MagiLog.add(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc private func presentViewController2() {
        self.present(ViewController2(), animated: true, completion: nil)
    }
    
    @objc private func log() {
        MagiLog.log("log")
    }
    
    func logDidRecord(with model: MagiLogModel) {
        print(model)
        print("ViewController logDidRecord")
    }


}

class ViewController2: UIViewController, MagiLogDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        btn.backgroundColor = UIColor.yellow
        btn.setTitle("Dismiss", for: .normal)
        btn.addTarget(self, action: #selector(ViewController2.dismissSelf), for: .touchUpInside)
        self.view.addSubview(btn)
        
        MagiLog.add(delegate: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MagiLog.log("ViewController2")
    }
    
    deinit {
        print("ViewController2 deinit")
    }
    
    @objc private func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func logDidRecord(with model: MagiLogModel) {
        print(model)
        print(model.file)
        print(model.message)
        print("ViewController2 logDidRecord")
    }
}

