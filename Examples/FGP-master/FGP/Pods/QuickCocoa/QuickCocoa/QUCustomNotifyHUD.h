//
//  QUCustomNotifyHUD.h
//  QuickCocoaDemo
//
//  Created by BriceZH on 2018/7/19.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QUCustomNotifyHUD : UIView

/** 提示内容Label */
@property (weak, nonatomic) UILabel *tipLabel;

+ (void)showHudAtViewCenterWithTipText:(NSString *)tipText delay:(NSTimeInterval)duration;

+ (void)showHudAtViewBottomWithTipText:(NSString *)tipText delay:(NSTimeInterval)duration;

@end
