//
//  QUPageContentView.h
//  QuickUI
//
//  Created by briceZhao on 2018/7/15.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QUPageScrollStyle.h"

static NSString *kPageContentViewCellId = @"kPageContentViewCellId";

@interface QUPageContentView : UIView <QUPageTitleViewDelegate>

@property (nonatomic, weak) id<QUPageContentViewDelegate> delegate;

@property (nonatomic, weak) NSArray *childVCs;

@property (nonatomic, weak) UIViewController *parentVC;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) CGFloat fromOffsetX;

@property (nonatomic, assign) BOOL isTitleClickForbidSVDelegate;

- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs;


@end
