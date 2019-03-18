//
//  RecordTableView.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

class RecordTableView: UITableView {
    
    private var timer: Timer?
    
    private var needScrollToBottom = false
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        separatorStyle = .none
        backgroundColor = UIColor.niceBlack()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func smoothReloadData(need scrollToBottom: Bool) {
        timer?.invalidate()
        timer = nil
        needScrollToBottom = false
        timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(RecordTableView.reloadData),
            userInfo: nil,
            repeats: false)
    }
    
    override func reloadData() {
        super.reloadData()
        
        if needScrollToBottom == true {
            DispatchQueue.main.async { [weak self] in
                self?.scrollToBottom(animated: true)
            }
        }
    }
    
    func scrollToBottom(animated: Bool) {
        let y = max(contentSize.height + contentInset.bottom - bounds.size.height, 0)
        let point = CGPoint(x: 0,
                            y: y)
        setContentOffset(point,
                         animated: animated)
    }

}

class RecordTableViewDataSource: NSObject {
    
    private let maxLogItems: Int = 1000
    private var logIndex: Int = 0
    fileprivate var type: RecordType
    fileprivate(set) var recordData: [RecordORMProtocol]?
    
    init(type: RecordType) {
        self.type = type
        super.init()
        self.type.model()?.addCount = 0
        recordData = currentPageModel()
    }
    
    private func currentPageModel() -> [RecordORMProtocol]? {
        switch type {
        case .log:
            return LogRecordModel.select(at: logIndex)
        case .crash:
            return CrashRecordModel.select(at: logIndex)
        case .network:
            return NetworkRecordModel.select(at: logIndex)
        case .caton:
            return CatonRecordModel.select(at: logIndex)
        case .command:
            return CommandRecordModel.select(at: logIndex)
        case .leak:
            return LeakRecordModel.select(at: logIndex)
        }
        //fatalError("type:\(type) not define the database")
    }
    
    private func addCount() {
        self.type.model()?.addCount += 1
    }
    
    func loadPrePage() -> Bool {
        self.logIndex += 1
        
        guard let models = self.currentPageModel() else {
            return false
        }
        
        guard models.count != 0 else {
            return false
        }
        
        for model in models.reversed() {
            recordData?.insert(model, at: 0)
        }
        return true
    }
    
    func addRecord(model: RecordORMProtocol) {
        
        if (recordData?.count ?? 0) != 0 &&
            Swift.type(of: model).type != type {
            return
        }
        
        recordData?.append(model)
        if (recordData?.count ?? 0) > maxLogItems {
            recordData?.remove(at: 0)
        }
        addCount()
    }
    
    func cleanRecord() {
        recordData?.removeAll()
    }
}

extension RecordTableViewDataSource: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return tableView.dequeueReusableCell({ (cell: RecordTableViewCell) in
            
        })
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as? RecordTableViewCell
        guard let data = recordData?[indexPath.row] else {
            return
        }
        let attributeString = data.attributeString()
        cell?.configure(attributeString)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableView = tableView as! RecordTableView
        
        let width = tableView.bounds.size.width - 10
        guard let data = recordData?[indexPath.row] else {
            return 0
        }
        let attributeString = data.attributeString()
        return RecordTableViewCell.boundingHeight(
            with: width,
            attributedText: attributeString)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if self.type == .network || self.type == .caton {
            return indexPath
        }else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = recordData?[indexPath.row] else { return }
        model.showAll = !model.showAll
        tableView.reloadData()
    }
}

