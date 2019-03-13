//
//  QUCustomNotifyHUD.m
//  QuickCocoaDemo
//
//  Created by BriceZH on 2018/7/19.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

#ifndef QUCustomNotifyHUD_h
#define QUCustomNotifyHUD_h

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define ScreenWidthScale (kScreenWidth/375.0)
#define ScreenHeightScale (kScreenHeight/667.0)

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavbarHeight 44

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define kTopLayoutHeight (kDevice_Is_iPhoneX ? 88 : 64)
#define kBottomLayoutHeight (kDevice_Is_iPhoneX ? 83 : 49)

#endif

#import "QUCustomNotifyHUD.h"

@implementation QUCustomNotifyHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.800];
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        self.alpha = 0;
        
        // 创建子视图
        [self setupSubViews];
        
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%@ has dealloc ~~~~~", [self class]);
}

// 创建子视图
- (void)setupSubViews
{
    // 提示Label
    UILabel *tipLabel = [[UILabel alloc] init];
    [self addSubview:tipLabel];
    _tipLabel = tipLabel;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.numberOfLines = 0;
    tipLabel.font = [UIFont systemFontOfSize:14.0];
    tipLabel.textAlignment = NSTextAlignmentCenter;
}

// 显示
+ (void)showHudAtViewCenterWithTipText:(NSString *)tipText delay:(NSTimeInterval)duration
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (tipText==nil || [tipText isEqualToString:@""]) return;
    
    for (UIView *notifyView in keyWindow.subviews) {
        if ([notifyView isMemberOfClass:[QUCustomNotifyHUD class]]) {
            return;
        }
    }
    
    QUCustomNotifyHUD *hud = [[QUCustomNotifyHUD alloc] initWithFrame:CGRectZero];
    [keyWindow addSubview:hud];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    // 对齐方式
    style.alignment = NSTextAlignmentCenter;
    // 首行缩进
    style.firstLineHeadIndent = 20.0f;
    // 头部缩进
    style.headIndent = 20.0f;
    // 尾部缩进
    style.tailIndent = -20.0f;
    // 行距
    style.minimumLineHeight = 18.f;
    style.lineSpacing = 6.f;
    
    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:tipText attributes:@{NSFontAttributeName : hud.tipLabel.font, NSParagraphStyleAttributeName : style}];
    
    hud.tipLabel.attributedText = attr;
    
    CGSize size = [tipText boundingRectWithSize:CGSizeMake(300 * ScreenWidthScale, kScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName : style} context:nil].size;
    
    hud.frame = CGRectMake(0, 0, size.width + 40, size.height + 20);
    hud.center = keyWindow.center;
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        hud.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.25 animations:^{
                hud.alpha = 0;
            } completion:^(BOOL finished) {
                [hud removeFromSuperview];
            }];
        });
    }];
}

+ (void)showHudAtViewBottomWithTipText:(NSString *)tipText delay:(NSTimeInterval)duration
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (tipText==nil || [tipText isEqualToString:@""]) return;
    
    for (UIView *notifyView in keyWindow.subviews) {
        if ([notifyView isMemberOfClass:[QUCustomNotifyHUD class]]) {
            return;
        }
    }
    
    QUCustomNotifyHUD *hud = [[QUCustomNotifyHUD alloc] initWithFrame:CGRectZero];
    [keyWindow addSubview:hud];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    // 对齐方式
    style.alignment = NSTextAlignmentCenter;
    // 首行缩进
    style.firstLineHeadIndent = 20.0f;
    // 头部缩进
    style.headIndent = 20.0f;
    // 尾部缩进
    style.tailIndent = -20.0f;
    // 行距
    style.minimumLineHeight = 18.f;
    style.lineSpacing = 6.f;
    
    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:tipText attributes:@{NSFontAttributeName : hud.tipLabel.font, NSParagraphStyleAttributeName : style}];
    
    hud.tipLabel.attributedText = attr;
    
    CGSize size = [tipText boundingRectWithSize:CGSizeMake(300 * ScreenWidthScale, kScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName : style} context:nil].size;
    
    hud.frame = CGRectMake((kScreenWidth - (size.width + 40))/2, kScreenHeight - kBottomLayoutHeight - (size.height + 20), size.width + 40, size.height + 20);
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        hud.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.25 animations:^{
                hud.alpha = 0;
            } completion:^(BOOL finished) {
                [hud removeFromSuperview];
            }];
        });
    }];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _tipLabel.frame = self.bounds;
}


@end
