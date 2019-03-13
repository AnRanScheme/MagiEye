//
//  QUPageScrollView.m
//  QuickUI
//
//  Created by briceZhao on 2018/7/15.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

#import "QUPageScrollView.h"
#import "QUPageTitleView.h"
#import "QUPageContentView.h"

@implementation QUPageScrollView

+ (instancetype)pageViewWithFrame:(CGRect)frame titles:(NSArray *)titles childVCs:(NSArray *)childVCs style:(QUPageScrollStyle *)style {
    QUPageScrollView *pageView = [[QUPageScrollView alloc]initWithFrame:frame];
    pageView.titles = titles;
    pageView.childVCs = childVCs;
    pageView.style = style;
    [pageView setupUI];
    return pageView;
}

- (void)setupUI {
    CGRect titleFrame = CGRectMake(0, 0, self.bounds.size.width, self.style.titleViewHeight);
    QUPageTitleView *titleView = [[QUPageTitleView alloc]initWithFrame:titleFrame titles:self.titles style:self.style];
    [self addSubview:titleView];
    
    CGRect contentFrame = CGRectMake(0, self.style.titleViewHeight, self.bounds.size.width, self.bounds.size.height - self.style.titleViewHeight);
    QUPageContentView *contentView = [[QUPageContentView alloc]initWithFrame:contentFrame childVCs:self.childVCs];
    [self addSubview:contentView];
    
    titleView.delegate = contentView;
    
    contentView.delegate = titleView;
}


- (void)dealloc {
    NSLog(@"%@ has dealloc ~~", [self class]);
}

@end
