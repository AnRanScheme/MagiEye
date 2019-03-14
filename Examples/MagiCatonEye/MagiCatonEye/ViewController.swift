//
//  ViewController.swift
//  MagiCatonEye
//
//  Created by anran on 2019/3/11.
//  Copyright © 2019 anran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var catonEye: MagiCatonEye?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.catonEye = MagiCatonEye()
        self.catonEye?.delegate = self
        self.catonEye?.open(with: 1)
        var s = ""
        for _ in 0..<9999 {
            for _ in 0..<9999 {
                s.append("1")
            }
        }
        
        print("invoke")
    }
    
}

extension ViewController: MagiCatonEyeDelegate {
  
    func catonEye(catonEye: MagiCatonEye,
                  catchWithThreshold threshold: Double,
                  mainThreadBacktrace: String?,
                  allThreadBacktrace: String?) {
        print("------------------")
        print(mainThreadBacktrace!)
        print("------------------")
        print(allThreadBacktrace!)
    }
    
}
