//
//  ConsoleViewController.swift
//  
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

class ConsoleController: UIViewController {
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.openEyes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.niceBlack()
        
        self.view.addSubview(self.tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    lazy var tableView: UITableView = { [unowned self] in
        let new = UITableView(frame: CGRect.zero, style: .grouped)
        new.delegate = self
        new.dataSource = self
        new.backgroundColor = UIColor.clear
        return new
    }()
    
    private(set) lazy var dataSource: [[RecordType]] = {
        var new = [[RecordType]]()
        var section1 = [RecordType]()
        section1.append(RecordType.log)
        section1.append(RecordType.crash)
        section1.append(RecordType.network)
        section1.append(RecordType.caton)
        section1.append(RecordType.leak)
        new.append(section1)
        
        var section2 = [RecordType]()
        section2.append(RecordType.command)
        new.append(section2)
        return new
    }()
    
    weak var printViewController: ConsolePrintViewController?
}
