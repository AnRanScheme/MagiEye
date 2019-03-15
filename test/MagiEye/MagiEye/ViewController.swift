//
//  ViewController.swift
//  MagiEye
//
//  Created by 安然 on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = { [unowned self] in
        let new = UITableView(frame: CGRect.zero,
                              style: .grouped)
        new.delegate = self
        new.dataSource = self
        new.frame = self.view.bounds
        return new
        }()
    
    fileprivate lazy var sections: [DemoSection] = {
        var new = [DemoSection]()
        new.append(DemoModelFactory.aslSection)
        new.append(DemoModelFactory.crashSection)
        new.append(DemoModelFactory.networkSection)
        new.append(DemoModelFactory.anrSection)
        return new
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MagiEye Feature List"
        view.backgroundColor = UIColor.black
        view.addSubview(self.tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MagiLog.log("just log")
        DispatchQueue.global().async {
            MagiLog.warning("just warning")
        }
        MagiLog.error("just error")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }

}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "DemoCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            cell?.textLabel?.font = UIFont(name: "Courier", size: 12)
        }
        
        cell!.textLabel?.text = self.sections[indexPath.section].model[indexPath.row].title
        return cell!
    }
    
}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        let label = UILabel(frame: CGRect(x: 10, y: 15, width: tableView.frame.size.width - 10, height: 20))
        label.backgroundColor = UIColor.clear
        label.font =  UIFont(name: "Courier", size: 14)
        label.text = self.sections[section].header
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.sections[indexPath.section].model[indexPath.row]
        model.action()
    }
    
}


