//
//  ConsoleViewController+Eye.swift
///
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

extension ConsoleController {
    
    /// open god's eyes
    func openEyes() {
        EyesManager.shared.delegate = self
        
        let defaultSwitch = MagiEyeController.shared.configuration!.defaultSwitch
        if defaultSwitch.asl { EyesManager.shared.openASLEye() }
        if defaultSwitch.log { EyesManager.shared.openMagiLogEye() }
        if defaultSwitch.crash { EyesManager.shared.openCrashEye() }
        if defaultSwitch.network { EyesManager.shared.openNetworkEye() }
        if defaultSwitch.caton { EyesManager.shared.openCatonEye() }
        if defaultSwitch.leak { EyesManager.shared.openLeakEye() }
    }
    
    func addRecord(model: RecordORMProtocol) {
        if let pc = self.printViewController {
            pc.addRecord(model: model)
        }else {
            let type = Swift.type(of: model).type
            type.addUnread()
            self.reloadRow(of: type)
        }
    }
}

extension ConsoleController: MagiLogDelegate {
    
    fileprivate func openMagiLogEye() {
        MagiLog.add(delegate: self)
    }
    
    func logDidRecord(with model: MagiLogModel) {
        let recordModel = LogRecordModel(model: model)
        recordModel.insert(complete: { [unowned self] (success:Bool) in
            self.addRecord(model: recordModel)
        })
    }
    
}

//MARK: - NetworkEye
extension ConsoleController: MagiNetworkEyeDelegate {
    /// god's network eye callback
    func networkEyeDidCatch(with request:URLRequest?,response:URLResponse?,data:Data?) {
        Store.shared.addNetworkByte(response?.expectedContentLength ?? 0)
        let model = NetworkRecordModel(request: request, response: response as? HTTPURLResponse, data: data)
        
        model.insert(complete:  { [unowned self] (success:Bool) in
            self.addRecord(model: model)
        })
    }
}
//MARK: - CrashEye
extension ConsoleController: MagiCrashEyeDelegate {
    
    /// god's crash eye callback
    func crashEyeDidCatchCrash(with model: MagiCrashModel) {
        let model = CrashRecordModel(model: model)
        model.insertSync(complete: { [unowned self] (success:Bool) in
            self.addRecord(model: model)
        })
    }
    
}

//MARK: - ASLEye
extension ConsoleController: MagiASLDelegate {
    /// god's asl eye callback
    func aslLog(_ aslLog: MagiASL, catchLogs logs: [String]) {
        for log in logs {
            let model = LogRecordModel(type: .asl, message: log)
            model.insert(complete: { [unowned self] (success:Bool) in
                self.addRecord(model: model)
            })
        }
    }
            
}

extension ConsoleController: MagiLeakEyeDelegate {
    
    func leakEye(_ leakEye: MagiLeakEye, didCatchLeak object: NSObject) {
        let model = LeakRecordModel(obj: object)
        model.insert { [unowned self] (success:Bool) in
            self.addRecord(model: model)
        }
    }

}

//MARK: - MagiCatonEyeDelegate
extension ConsoleController: MagiCatonEyeDelegate {
    /// god's anr eye callback
    func catonEye(catonEye: MagiCatonEye,
                  catchWithThreshold threshold: Double,
                  mainThreadBacktrace: String?,
                  allThreadBacktrace: String?) {
        let model = CatonRecordModel(threshold: threshold,
                                     mainThreadBacktrace: mainThreadBacktrace,
                                     allThreadBacktrace: allThreadBacktrace)
        model.insert(complete:  { [unowned self] (success:Bool) in
            self.addRecord(model: model)
        })
    }
}
