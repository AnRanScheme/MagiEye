//
//  ViewController.swift
//  MagiCrash
//
//  Created by anran on 2019/3/11.
//  Copyright © 2019 anran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MagiCrashEye.add(delegate: self)
        let arr = [1]
        arr[10]
    }

}

extension ViewController: MagiCrashEyeDelegate {
    
    func crashEyeDidCatchCrash(with model: MagiCrashModel) {
        print(model)
    }
    
}

