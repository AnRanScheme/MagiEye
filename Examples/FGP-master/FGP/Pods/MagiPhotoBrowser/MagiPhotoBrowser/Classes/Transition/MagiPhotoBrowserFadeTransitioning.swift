//
//  MagiPhotoBrowserFadeTransitioning.swift
//  MagiPhotoBrowser_Example
//
//  Created by anran on 2018/10/26.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

public class MagiPhotoBrowserFadeTransitioning: MagiPhotoBrowserTransitioning {
    public override init() {
        super.init()
        self.presentingAnimator = MagiPhotoBrowserFadePresentingAnimator()
        self.dismissingAnimator = MagiPhotoBrowserFadeDismissingAnimator()
    }
}
