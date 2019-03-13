//
//  QUPageTitleView.h
//  QuickUI
//
//  Created by briceZhao on 2018/7/15.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QUPageScrollStyle.h"

@interface QUPageTitleView : UIView <QUPageContentViewDelegate>

@property (nonatomic, weak) id<QUPageTitleViewDelegate> delegate;

@property (nonatomic, weak) NSArray *titles;

@property (nonatomic, weak) QUPageScrollStyle *style;

@property (nonatomic, assign) NSInteger currentIndex;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles style:(QUPageScrollStyle *)style;

@end
