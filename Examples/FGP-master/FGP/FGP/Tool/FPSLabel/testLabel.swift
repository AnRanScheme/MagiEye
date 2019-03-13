//
//  testLabel.swift
//  FGP
//
//  Created by 安然 on 2019/3/13.
//  Copyright © 2019 BriceZhao. All rights reserved.
//

import UIKit

class TestMagiFPSLabel: UILabel {
    
    var link: CADisplayLink?
    var count: Int = 0
    var lastTime: TimeInterval = 0
    var llll: TimeInterval?
    var fonts: UIFont = UIFont(name: "Menlo", size: 14)!
    var subFont: UIFont = UIFont(name: "Menlo", size: 12)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        clipsToBounds = true
        textAlignment = .center
        isUserInteractionEnabled = false
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        link = CADisplayLink(target: self,
                             selector: #selector(tick(link:)))
        link?.frameInterval = 2
        link?.add(to: RunLoop.main,
                  forMode: RunLoop.Mode.common)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        link?.invalidate()
        link = nil
    }
    
    @objc fileprivate func tick(link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }
        count += link.frameInterval
        
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
        
        let attributedString = NSMutableAttributedString(string: String(format: "%lf FPS", fps))
        
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
    
}

