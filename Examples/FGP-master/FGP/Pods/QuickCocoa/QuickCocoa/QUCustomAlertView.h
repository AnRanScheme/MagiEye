//
//  QUCustomAlertView.h
//  QuickCocoaDemo
//
//  Created by BriceZH on 2018/7/19.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN const CGFloat kCustomAlertViewButtonHeight;
UIKIT_EXTERN const CGFloat kCustomAlertViewCornerRadius;

@class QUCustomAlertView;

@protocol QUCustomAlertViewDelegate <NSObject>

- (void)CustomAlertViewTouchUpInside:(QUCustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface QUCustomAlertView : UIView <QUCustomAlertViewDelegate>

@property (nonatomic, strong) UIView *parrentView;

@property (nonatomic, strong) UIView *dialogBoxView;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) NSArray *buttonTitles;

@property (nonatomic, assign) BOOL isUseMotionEffects;

@property (nonatomic, assign) BOOL closeOnTouchUpOutside;

@property (nonatomic, weak) id<QUCustomAlertViewDelegate> delegate;

@property (nonatomic, copy) void(^onButtonTouchUpInside) (QUCustomAlertView *alertView, NSUInteger buttonIndex); ;//the AlertView when finger is lifted outside the bounds.

- (instancetype)init;
- (instancetype)initWithParrentView:(UIView *)parrentView;

- (void)show;
- (void)close;


@end
