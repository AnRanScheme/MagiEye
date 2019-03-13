//
//  QUPageScrollView.h
//  QuickUI
//
//  Created by briceZhao on 2018/7/15.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QUPageScrollStyle.h"

@interface QUPageScrollView : UIView

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSArray *childVCs;

@property (nonatomic, strong) QUPageScrollStyle *style;

+ (instancetype)pageViewWithFrame:(CGRect)frame titles:(NSArray *)titles childVCs:(NSArray *)childVCs style:(QUPageScrollStyle *)style;

@end
