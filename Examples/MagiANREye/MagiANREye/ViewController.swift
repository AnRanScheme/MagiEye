//
//  ViewController.swift
//  MagiANREye
//
//  Created by anran on 2019/4/1.
//  Copyright © 2019 anran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var anrEye: MagiANREye?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MagiAppFluecyMonitor.shared.start()
        LXDAppFluecyMonitor.shared()?.startMonitoring()
        self.anrEye = MagiANREye()
        self.anrEye?.delegate = self
        self.anrEye?.open(with: 1)
        var s = ""
        for _ in 0..<9999 {
            for _ in 0..<9999 {
                s.append("1")
            }
        }
        
        print("invoke")
    }
    
}

extension ViewController: MagiANREyeDelegate {
    
//    func anrEye(anrEye: MagiANREye,
//                catchWithThreshold threshold: Double,
//                mainThreadBacktrace: String?,
//                allThreadBacktrace: String?) {
//        print("------------------")
//        print(mainThreadBacktrace!)
//        print("------------------")
//        print(allThreadBacktrace!)
//    }
    
}

