//
//  QUPageScrollStyle.h
//  QuickUI
//
//  Created by briceZhao on 2018/7/15.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QUPageTitleView, QUPageContentView;

@protocol QUPageTitleViewDelegate <NSObject>

@optional

- (void)pageTitleView:(QUPageTitleView *)titleView targetIndex:(NSInteger)targetIndex;
@end

@protocol QUPageContentViewDelegate <NSObject>

- (void)pageContentView:(QUPageContentView *)contentView didEndScrollToIndex:(NSInteger)index;

- (void)pageContentView:(QUPageContentView *)contentView sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex progress:(CGFloat)progress;
@end

@interface QUPageScrollStyle : NSObject

@property (nonatomic, assign) CGFloat titleViewHeight; //导航条的高度，一般不用修改: 默认 50

@property (nonatomic, strong) UIFont *titleFont; //导航条上的字体大小: 默认 16

@property (nonatomic, assign) BOOL isNeedTitleScale; //是否需要做标题缩放动画支持: 默认 NO

@property (nonatomic, assign) BOOL isScrollEnable; //默认等分模式: NO (显示在一屏内)，滚动模式: YES (页数多时，设置为滚动模式，此时下划线的长度是根据各个标题内容自适应)

@property (nonatomic, assign) CGFloat titleMargin; //滚动模式下标题之间的间距: 默认 20

@property (nonatomic, strong) UIColor *titleNorColor; //正常时的标题文字颜色: 默认 r:34 g:34 b:34

@property (nonatomic, strong) UIColor *titleSelColor; //选中时的标题文字颜色: 默认 r:80 g:140 b:238

@property (nonatomic, assign) BOOL isShowBottomLine; //默认有跟踪滚动条: YES（下划线）

@property (nonatomic, strong) UIColor *bottomLineColor; //下划线颜色: 默认 r:80 g:140 b:238

@property (nonatomic, assign) CGFloat bottomLineExtendWidth; //下划线的Inset: 默认 18

@property (nonatomic, assign) CGFloat bottomLineHeight; //下划线的高度: 默认 2

@property (nonatomic, assign) CGFloat bottomLineMargin; //下划线到TitleView底部的距离: 默认 5

@property (nonatomic, assign) CGFloat scaleRatio; //缩放比例，如有需要可以设置1.1～1.4比较合适: 默认 1.2

+ (instancetype)style;

@end

