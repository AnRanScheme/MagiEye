//
//  MonitorContainerView.swift
//  Pods
//
//  Created by zixun on 17/1/6.
//
//

import Foundation
import UIKit

protocol MonitorContainerViewDelegate: class {
    func container(container: MonitorContainerView, didSelectedType type: MonitorSystemType)
}

class MonitorContainerView: UIScrollView {
    
    weak var delegateContainer: MonitorContainerViewDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        addSubview(deviceView)
        addSubview(sysNetView)
        fps.open()
        networkFlow.open()
        deviceView.configure(
            nameString: MagiSystemEye.hardware.deviceModel,
            osString: MagiSystemEye.hardware.systemName + " " + MagiSystemEye.hardware.systemVersion)
        
        Store.shared.networkByteDidChange { [weak self] (byte:Double) in
            self?.appNetView.configure(byte: byte)
        }
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(timerHandler),
                             userInfo: nil,
                             repeats: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        deviceView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: frame.size.width,
                                  height: 100)

        for i in 0..<monitorAppViews.count {
            var rect = deviceView.frame
            rect.origin.y = rect.maxY
            rect.size.width = frame.size.width / 2.0
            rect.size.height = 100
            rect.origin.y += rect.size.height * CGFloat( i / 2)
            rect.origin.x += rect.size.width * CGFloat( i % 2)
            monitorAppViews[i].frame = rect
        }
        
        for i in 0..<monitorSysViews.count {
            var rect = monitorAppViews.last?.frame ?? CGRect.zero
            rect.origin.y += rect.size.height
            rect.origin.x = 0
            rect.origin.y += rect.size.height * CGFloat( i / 2)
            rect.origin.x += rect.size.width * CGFloat( i % 2)
            monitorSysViews[i].frame = rect
        }
        
        var rect = monitorSysViews.last?.frame ?? CGRect.zero
        rect.origin.y += rect.size.height
        rect.origin.x = 0
        rect.size.width = frame.size.width
        sysNetView.frame = rect
        
        contentSize = CGSize(width: frame.size.width, height: sysNetView.frame.maxY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: PRIVATE FUNCTION
    @objc
    private func didTap(sender: MonitorBaseView) {
        delegateContainer?.container(container: self, didSelectedType: sender.type)
    }
    
    @objc
    private func didTapSysNetView(sender: MonitorSysNetFlowView) {
        delegateContainer?.container(container: self, didSelectedType: sender.type)
    }
    
    @objc
    private func timerHandler() {
        
        appCPUView.configure(percent: MagiSystemEye.cpu.applicationUsage())
        
        let cpuSystemUsage = MagiSystemEye.cpu.systemUsage()
        sysCPUView.configure(percent: cpuSystemUsage.system + cpuSystemUsage.user + cpuSystemUsage.nice)
        
        appRAMView.configure(byte: MagiSystemEye.memory.applicationUsage().used)
        
        let ramSysUsage = MagiSystemEye.memory.systemUsage()
        let percent = (ramSysUsage.active + ramSysUsage.inactive + ramSysUsage.wired) / ramSysUsage.total
        sysRAMView.configure(percent: percent * 100.0)
        
    }

    // MARK: PRIVATE PROPERTY
    private lazy var fps: MagiFPS = { [unowned self] in
        let new = MagiFPS()
        new.delegate = self
        return new
    }()
    
    private lazy var networkFlow: MagiNetworkFlow = {
        let new = MagiNetworkFlow()
        new.delegate = self
        return new
    }()
    
    private var deviceView = MonitorDeviceView()
    
    private lazy var appCPUView: MonitorBaseView = { [unowned self] in
        let new = MonitorBaseView(type: MonitorSystemType.appCPU)
        new.addTarget(self, action: #selector(MonitorContainerView.didTap(sender:)), for: .touchUpInside)
        return new
    }()
    
    private lazy var appRAMView: MonitorBaseView = { [unowned self] in
        let new = MonitorBaseView(type: MonitorSystemType.appRAM)
        new.addTarget(self, action: #selector(MonitorContainerView.didTap(sender:)), for: .touchUpInside)
        return new
    }()
    
    private lazy var appFPSView: MonitorBaseView = { [unowned self] in
        let new = MonitorBaseView(type: MonitorSystemType.appFPS)
        new.addTarget(self, action: #selector(MonitorContainerView.didTap(sender:)), for: .touchUpInside)
        return new
    }()
    
    private lazy var appNetView: MonitorBaseView = { [unowned self] in
        let new = MonitorBaseView(type: MonitorSystemType.appNET)
        new.addTarget(self, action: #selector(MonitorContainerView.didTap(sender:)), for: .touchUpInside)
        return new
    }()

    private lazy var sysCPUView: MonitorBaseView = { [unowned self] in
        let new = MonitorBaseView(type: MonitorSystemType.sysCPU)
        new.addTarget(self, action: #selector(MonitorContainerView.didTap(sender:)), for: .touchUpInside)
        return new
    }()
    
    private lazy var sysRAMView: MonitorBaseView = { [unowned self] in
        let new = MonitorBaseView(type: MonitorSystemType.sysRAM)
        new.addTarget(self, action: #selector(MonitorContainerView.didTap(sender:)), for: .touchUpInside)
        return new
    }()
    
    private lazy var sysNetView: MonitorSysNetFlowView = { [unowned self] in
        let new = MonitorSysNetFlowView(type: MonitorSystemType.sysNET)
        new.addTarget(self, action: #selector(MonitorContainerView.didTapSysNetView(sender:)), for: .touchUpInside)
        return new
    }()
    
    private lazy var monitorAppViews: [MonitorBaseView] = { [unowned self] in
        var new = [MonitorBaseView]()
        addSubview(appCPUView)
        addSubview(appRAMView)
        addSubview(appFPSView)
        addSubview(appNetView)
        
        new.append(appCPUView)
        new.append(appRAMView)
        new.append(appFPSView)
        new.append(appNetView)
        
        for i in 0..<new.count {
            new[i].firstRow = i < 2
            new[i].position = i % 2 == 0 ? .left : .right
        }
        return new
    }()
    
    private lazy var monitorSysViews: [MonitorBaseView] = { [unowned self] in
        var new = [MonitorBaseView]()
        
        addSubview(sysCPUView)
        addSubview(sysRAMView)
        new.append(sysCPUView)
        new.append(sysRAMView)
        
        for i in 0..<new.count {
            new[i].firstRow = i < 2
            new[i].position = i % 2 == 0 ? .left : .right
        }
        return new
    }()
}

extension MonitorContainerView: MagiFPSDelegate {
    func fps(fps: MagiFPS, currentFPS: Double) {
        appFPSView.configure(fps: currentFPS)
    }
}

extension MonitorContainerView: MagiNetDelegate {
    func networkFlow(networkFlow: MagiNetworkFlow,catchWithWifiSend wifiSend:UInt32,wifiReceived:UInt32,wwanSend:UInt32,wwanReceived:UInt32) {
        sysNetView.configure(wifiSend: wifiSend, wifiReceived: wifiReceived, wwanSend: wwanSend, wwanReceived: wwanReceived)
    }
}
