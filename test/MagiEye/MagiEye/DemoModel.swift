//
//  DemoModel.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

func alert(t: String, m: String) {
    DispatchQueue.main.async {
        let alertView = UIAlertView()
        alertView.title = t
        alertView.message = m
        alertView.addButton(withTitle: "OK")
        alertView.show()
    }
}

class DemoModel: NSObject {
    
    private(set) var title: String
    
    private(set) var action: (()->())
    
    init(title: String, action: @escaping ()->()) {
        self.title = title
        self.action = action
        super.init()
    }
    
}

class DemoSection: NSObject {
    private(set) var header: String
    private(set) var model:[DemoModel]
    
    init(header: String, model: [DemoModel]) {
        self.header = header
        self.model = model
        super.init()
    }
}

class DemoModelFactory: NSObject {
    
    static var crashSection: DemoSection {
        var models = [DemoModel]()
        var model = DemoModel(title: "Exception Crash") {
            let array = NSArray()
            _ = array[2]
        }
        models.append(model)
        
        model = DemoModel(title: "Signal Crash") {
            var a = [String]()
            _ = a[2]
        }
        models.append(model)
        
        return DemoSection(header: "Crash", model: models)
    }
    
    static var networkSection: DemoSection {
        let url = URL(string: "https://api.github.com/search/users?q=language:objective-c&sort=followers&order=desc")
        let request = URLRequest(url: url!)
        
        var new = [DemoModel]()
        
        var title = "Send Sync Connection Network"
        var model = DemoModel(title: title) {
            _ = try! NSURLConnection.sendSynchronousRequest(request, returning: nil)
            alert(t: "Completed", m: title)
        }
        new.append(model)
        
        title = "Send Async Connection Network"
        model = DemoModel(title: title) {
            NSURLConnection.sendAsynchronousRequest(request,
                                                    queue: OperationQueue.main,
                                                    completionHandler: {(response, data, error) in
                                                        alert(t: "Completed", m: title)
            })
        }
        new.append(model)
        
        title = "Send Shared Session Network"
        model = DemoModel(title: title) {
            let session = URLSession.shared
            URLSession.shared.dataTask(with: request)
            let task = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
                alert(t: "Completed", m: title)
            }
            task.resume()
        }
        new.append(model)
        
        title = "Send Configuration Session Network"
        model = DemoModel(title: title) {
            let configure = URLSessionConfiguration.default
            let session = URLSession(configuration: configure,
                                     delegate: nil,
                                     delegateQueue: OperationQueue.current)
            let task = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
                alert(t: "Completed", m: title)
            }
            task.resume()
        }
        new.append(model)
        
        return DemoSection(header: "Network", model: new)
    }
    
    static var aslSection: DemoSection {
        var models = [DemoModel]()
        let model = DemoModel(title: "NSLog") {
            NSLog("test")
        }
        models.append(model)
        
        return DemoSection(header: "ASL", model: models)
    }
    
    static var anrSection: DemoSection {
        var models = [DemoModel]()
        
        let title = "Simulate ANR"
        let model = DemoModel(title: title) {
            sleep(4)
            alert(t: "Completed", m: title)
        }
        models.append(model)
        
        return DemoSection(header: "ANR", model: models)
    }
    
}
