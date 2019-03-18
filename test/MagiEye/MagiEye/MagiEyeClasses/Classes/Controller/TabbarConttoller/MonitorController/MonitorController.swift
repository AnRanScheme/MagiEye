//
//  MonitorViewController.swift
//  Pods
//
//  Created by zixun on 16/12/27.
//
//

import Foundation

class MonitorController: UIViewController {
    
    private var containerView = MonitorContainerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.delegateContainer = self
        view.addSubview(self.containerView)
        view.backgroundColor = UIColor.niceBlack()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        containerView.frame = self.view.bounds
    }
 
}

extension MonitorController: MonitorContainerViewDelegate {
    
    func container(container:MonitorContainerView, didSelectedType type:MonitorSystemType) {
        UIAlertView.quickTip(message: "detail and historical data coming soon")
        
        if type.hasDetail {
            //TODO: add detail
        }
    }
    
}

