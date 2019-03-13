//
//  QUPageScrollStyle.m
//  QuickUI
//
//  Created by briceZhao on 2018/7/15.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

#import "QUPageScrollStyle.h"

@implementation QUPageScrollStyle

+ (instancetype)style {
    QUPageScrollStyle *pv = [[self alloc]init];
    pv.titleViewHeight = 50.f;
    pv.titleFont = [UIFont systemFontOfSize:16.f];
    pv.isNeedTitleScale = NO;
    pv.isScrollEnable = NO;
    pv.titleMargin = 20;
    pv.titleNorColor = [UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
    pv.titleSelColor = [UIColor colorWithRed:80.0/255.0 green:140.0/255.0 blue:238.0/255.0 alpha:1.0];
    pv.isShowBottomLine = YES;
    pv.bottomLineColor = [UIColor colorWithRed:80.0/255.0 green:140.0/255.0 blue:238.0/255.0 alpha:1.0];
    pv.bottomLineExtendWidth = 0.f;
    pv.bottomLineHeight = 2.f;
    pv.bottomLineMargin = 5.f;
    pv.scaleRatio = 1.2;
    return pv;
}

@end
