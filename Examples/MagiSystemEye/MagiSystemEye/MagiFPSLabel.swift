//
//  MagiFPSLabel.swift
//  FGP
//
//  Created by anran on 2018/8/29.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit

class MagiFPSMonitor {
    
    static let shared = MagiFPSMonitor()
    private let fpsLabel = MagiFPSLabel()
    open var isEnable: Bool = true {
        didSet {
            fpsLabel.isEnable = isEnable
        }
    }
    
    func start() {
        if let app = UIApplication.shared.delegate,
            let window = app.window {
            window?.addSubview(fpsLabel)
            window?.bringSubviewToFront(fpsLabel)
            fpsLabel.start()
        }
    }
    
    func stop() {
        fpsLabel.stop()
    }
}


class MagiFPSLabel: UILabel {
    
    private var count: Int = 0
    open var isEnable: Bool = true
    private var lastTime: TimeInterval = 0
    private var fonts: UIFont = UIFont(
        name: "Menlo", size: 14)
        ?? UIFont.systemFont(ofSize: 14)
    private var subFont: UIFont = UIFont(
        name: "Menlo", size: 12)
        ?? UIFont.systemFont(ofSize: 12)
    private static let kRect = CGRect(x: 40,
                                      y: 100,
                                      width: 80,
                                      height: 30)
    private lazy var displayLink: CADisplayLink = { [unowned self] in
        let new = CADisplayLink(
            target: self,
            selector: #selector(displayLinkHandler(link:)))
        new.isPaused = true
        new.add(to: RunLoop.main,
                forMode: .common)
        return new
        }()
    
    override init(frame: CGRect) {
        var realFrame = frame
        if (realFrame.size.width == 0
            && realFrame.size.height == 0) {
            realFrame = MagiFPSLabel.kRect
        }
        super.init(frame: realFrame)
        setupUI()
        AddNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        displayLink.remove(from: .main,
                           forMode: .common)
        displayLink.invalidate()
    }

}

// MARK: - Customsize
extension MagiFPSLabel {
    
    fileprivate func setupUI() {
        clipsToBounds = true
        layer.cornerRadius = 8
        textAlignment = .center
        isUserInteractionEnabled = true
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    fileprivate func AddNotification() {
        let pan = UIPanGestureRecognizer(
            target: self,
            action: #selector(pan(sender:)))
        addGestureRecognizer(pan)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillResignActiveNotification),
            name: UIApplication.willResignActiveNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActiveNotification),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
    }
    
    fileprivate func start() {
        guard self.isEnable == true else {
            return
        }
        displayLink.isPaused = false
    }
    
    fileprivate func stop() {
        guard self.isEnable == true else {
            return
        }
        displayLink.isPaused = true
    }
    
    
}

// MARK: - Action
extension MagiFPSLabel {
    
    @objc
    fileprivate func displayLinkHandler(link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }
        count += 1
        
        let delta = link.timestamp - lastTime
        if delta < 1 {return}
        lastTime = link.timestamp
        let fps: Double = Double(count)/delta
        count = 0
        let progress = fps / 60.0
        let color = UIColor(hue: CGFloat(0.27*(progress-0.2)),
                            saturation: 1,
                            brightness: 0.9,
                            alpha: 1)
        
        let attributedString = NSMutableAttributedString(string: String(format: "%0.1f FPS", fps))
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color,
                                      range: NSMakeRange(0, attributedString.length - 3))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color,
                                      range: NSMakeRange(attributedString.length - 3, 3))
        attributedString.addAttribute(NSAttributedString.Key.font, value: fonts,
                                      range: NSMakeRange(0, attributedString.length - 3))
        attributedString.addAttribute(NSAttributedString.Key.font, value: subFont,
                                      range: NSMakeRange(attributedString.length - 3, 3))
        attributedText = attributedString
    }
    
    @objc
    fileprivate func pan(sender: UIPanGestureRecognizer) {
        guard let window1 = UIApplication.shared.delegate?.window else {
            return
        }
        guard let window = window1 else {
            return
        }
        print(sender.location(in: window))
        switch sender.state {
        case .began:
            alpha = 0.5
        case .changed:
            center = sender.location(in: window)
        case .ended:
            let x = min(window.frame.width - frame.width,
                        max(0, frame.origin.x))
            let y = min(window.frame.height - frame.height,
                        max(0, frame.origin.y))
            let newFrame = CGRect(x: x,
                                  y: y,
                                  width: frame.width,
                                  height: frame.height)
            UIView.animate(withDuration: 0.2, animations: {
                self.frame = newFrame
                self.alpha = 1
            })
        default:
            break
        }
        
    }
    
    @objc
    fileprivate func applicationWillResignActiveNotification() {
        guard self.isEnable == true else {
            return
        }
        
        self.displayLink.isPaused = true
    }
    
    @objc
    fileprivate func applicationDidBecomeActiveNotification() {
        guard self.isEnable == true else {
            return
        }
        self.displayLink.isPaused = false
    }
    
}
