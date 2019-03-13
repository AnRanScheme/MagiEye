//
//  MagiFPSLabel.swift
//  FGP
//
//  Created by anran on 2018/8/29.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit

class MagiFPSMonitor {
    
    static let shared =  MagiFPSMonitor()
    private let fpsLabel = MagiFPSLabel()

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
    
    private var link: CADisplayLink?
    private var count: Int = 0
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
    
    override init(frame: CGRect) {
        var f = frame
        if (f.size.width == 0 && f.size.height == 0) {
            f = MagiFPSLabel.kRect
        }
        super.init(frame: f)
        layer.cornerRadius = 8
        clipsToBounds = true
        textAlignment = .center
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        isUserInteractionEnabled = true
        link = CADisplayLink(target: self,
                             selector: #selector(tick(link:)))
        link?.isPaused = true
        link?.add(to: RunLoop.main,
                  forMode: RunLoop.Mode.common)
        let pan = UIPanGestureRecognizer(target: self,
                                     action: #selector(pan(sender:)))
        addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        link?.remove(from: .main, forMode: .common)
        link?.invalidate()
        link = nil
    }
    
    @objc
    fileprivate func tick(link: CADisplayLink) {
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
    
    fileprivate func start() {
        link?.isPaused = false
    }
    
    fileprivate func stop() {
        link?.isPaused = true
    }
    
    @objc
    fileprivate func pan(sender: UIPanGestureRecognizer) {
        guard let window1 = UIApplication.shared.delegate?.window else {
            return
        }
        print(sender.location(in: window))
        switch sender.state {
        case .began:
            alpha = 0.5
        case .changed:
            center = sender.location(in: window)
        case .ended:
            let x = min(window1!.frame.width - frame.width,
                        max(0, frame.origin.x))
            let y = min(window1!.frame.height - frame.height,
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

}
