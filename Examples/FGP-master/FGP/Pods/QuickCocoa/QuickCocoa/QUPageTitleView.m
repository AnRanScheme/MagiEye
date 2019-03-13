//
//  QUPageTitleView.m
//  QuickUI
//
//  Created by briceZhao on 2018/7/15.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

#import "QUPageTitleView.h"
#import "QUPageContentView.h"

typedef struct {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
} ColorRGB;

ColorRGB ColorRGBMake(CGFloat red, CGFloat green, CGFloat blue) {
    ColorRGB color = {0.f, 0.f, 0.f};
    color.red = red;
    color.green = green;
    color.blue = blue;
    return color;
}

@interface QUPageTitleView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray<UILabel *> *titleLabels;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, assign) ColorRGB norRGB;

@property (nonatomic, assign) ColorRGB selRGB;

@property (nonatomic, assign) ColorRGB deltaRGB;

@end

@implementation QUPageTitleView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles style:(QUPageScrollStyle *)style {
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        self.style = style;
        self.titleLabels = [NSMutableArray arrayWithCapacity:titles.count];
        self.norRGB = ColorRGBMake(34.f / 255.f, 34.f / 255.f, 34.f / 255.f);
        self.selRGB = ColorRGBMake(80.f / 255.f, 140.f / 255.f, 238.f / 255.f);
        self.deltaRGB = ColorRGBMake(self.selRGB.red-self.norRGB.red, self.selRGB.green-self.norRGB.green, self.selRGB.blue-self.norRGB.blue);
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview: self.scrollView];
    [self setupLabels];
    [self setupBottomLine];
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = self.style.bottomLineColor;
    }
    return _bottomLine;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
    }
    return _scrollView;
}

- (void)setupLabels {
    __weak typeof(self) weakSelf = self;
    [self.titles enumerateObjectsUsingBlock:^(NSString *  _Nonnull title, NSUInteger index, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = title;
        titleLabel.tag = index;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = index==0 ? strongSelf.style.titleSelColor : strongSelf.style.titleNorColor;
        titleLabel.font = strongSelf.style.titleFont;
        [strongSelf.scrollView addSubview:titleLabel];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabelClick:)];
        titleLabel.userInteractionEnabled = YES;
        [titleLabel addGestureRecognizer:tapGesture];
        [strongSelf.titleLabels addObject:titleLabel];
    }];
    CGFloat labelW = self.bounds.size.width / self.titleLabels.count;
    CGFloat labelH = self.style.titleViewHeight - self.style.bottomLineHeight - self.style.bottomLineMargin;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    
    UILabel *lastLabel = nil;
    for (UILabel *titleLabel in self.titleLabels) {
        if (self.style.isScrollEnable) {
            NSAttributedString *attr = [[NSAttributedString alloc]initWithString:titleLabel.text attributes:@{NSFontAttributeName : self.style.titleFont}];
            labelW = [attr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, labelH) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
            labelX = titleLabel.tag == 0 ? self.style.titleMargin * 0.5 : CGRectGetMaxX(lastLabel.frame) + self.style.titleMargin;
        } else {
            labelX = labelW * titleLabel.tag;
        }
        lastLabel = titleLabel;
        titleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
    }
    if (self.style.isScrollEnable) {
        self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(self.titleLabels.lastObject.frame) + self.style.titleMargin+0.5, 0);
    }
    
    if (self.style.isNeedTitleScale) {
        self.titleLabels.firstObject.transform = CGAffineTransformMakeScale(self.style.scaleRatio, self.style.scaleRatio);
    }
}

- (void)setupBottomLine {
    if (self.style.isShowBottomLine) {
        [self.scrollView addSubview:self.bottomLine];
        self.bottomLine.frame = self.titleLabels.firstObject.frame;
    }
    self.bottomLine.frame = CGRectMake(self.bottomLine.frame.origin.x, self.style.titleViewHeight - self.style.bottomLineHeight - self.style.bottomLineMargin, self.bottomLine.frame.size.width, self.style.bottomLineHeight);
}


- (void)titleLabelClick:(UITapGestureRecognizer *)gesture {
    if (![gesture.view isKindOfClass:[UILabel class]] || (gesture.view.tag == self.currentIndex)) {
        return;
    }
    UILabel *targetLabel = (UILabel *)gesture.view;
    UILabel *sourceLabel = self.titleLabels[self.currentIndex];
    sourceLabel.textColor = self.style.titleNorColor;
    targetLabel.textColor = self.style.titleSelColor;
    self.currentIndex = targetLabel.tag;
    
    [self adjustLabelPos];
    
    if ([self.delegate respondsToSelector:@selector(pageTitleView:targetIndex:)]) {
        [self.delegate pageTitleView:self targetIndex:self.currentIndex];
    }
    if (self.style.isNeedTitleScale) {
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransformIsIdentity(sourceLabel.transform);
            targetLabel.transform = CGAffineTransformMakeScale(self.style.scaleRatio, self.style.scaleRatio);
        }];
    }
    if (self.style.isShowBottomLine) {
        CGRect bottomFrame = self.bottomLine.frame;
        [UIView animateWithDuration:0.3 animations:^{
            if (self.style.isScrollEnable) {
                self.bottomLine.frame = CGRectMake(targetLabel.frame.origin.x +  self.style.bottomLineExtendWidth, bottomFrame.origin.y, targetLabel.frame.size.width - 2 * self.style.bottomLineExtendWidth, bottomFrame.size.height);
            } else {
                self.bottomLine.frame = CGRectMake(targetLabel.frame.origin.x - self.style.bottomLineExtendWidth, bottomFrame.origin.y, targetLabel.frame.size.width + 2 * self.style.bottomLineExtendWidth, bottomFrame.size.height);
            }
        }];
    }
}

- (void)pageContentView:(QUPageContentView *)contentView didEndScrollToIndex:(NSInteger)index {
    self.currentIndex = index;
    [self adjustLabelPos];
}

- (void)pageContentView:(QUPageContentView *)contentView sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex progress:(CGFloat)progress {
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    
    sourceLabel.textColor = [UIColor colorWithRed:(self.selRGB.red - self.deltaRGB.red * progress) green:(self.selRGB.green - self.deltaRGB.green * progress) blue:(self.selRGB.blue - self.deltaRGB.blue * progress) alpha:1.0];
    targetLabel.textColor = [UIColor colorWithRed:(self.norRGB.red + self.deltaRGB.red * progress) green:(self.norRGB.green + self.deltaRGB.green * progress) blue:(self.norRGB.blue + self.deltaRGB.blue * progress) alpha:1.0];
    
    if (self.style.isNeedTitleScale) {
        CGFloat deltaScale = self.style.scaleRatio - 1.f;
        sourceLabel.transform = CGAffineTransformMakeScale(self.style.scaleRatio - deltaScale * progress, self.style.scaleRatio - deltaScale * progress);
        targetLabel.transform = CGAffineTransformMakeScale(1 + deltaScale * progress, 1 + deltaScale * progress);
    }
    CGFloat deltaWidth = targetLabel.frame.size.width - sourceLabel.frame.size.width;
    CGFloat deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
    
    if (self.style.isShowBottomLine) {
        CGRect bottomFrame = self.bottomLine.frame;
        if (self.style.isScrollEnable) {
            self.bottomLine.frame = CGRectMake(sourceLabel.frame.origin.x + deltaX * progress +  self.style.bottomLineExtendWidth, bottomFrame.origin.y, sourceLabel.frame.size.width + deltaWidth * progress - 2 * self.style.bottomLineExtendWidth, bottomFrame.size.height);
        } else {
            self.bottomLine.frame = CGRectMake(sourceLabel.frame.origin.x + deltaX * progress - self.style.bottomLineExtendWidth, bottomFrame.origin.y, sourceLabel.frame.size.width + deltaWidth * progress + 2 * self.style.bottomLineExtendWidth, bottomFrame.size.height);
        }
    }
}

- (void)adjustLabelPos {
    UILabel *targetLabel = self.titleLabels[self.currentIndex];
    CGFloat offset = targetLabel.center.x - self.scrollView.frame.size.width * 0.5;
    if (offset < 0) {
        offset = 0;
    }
    CGFloat maxOffset = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

- (void)dealloc {
    NSLog(@"%@ has dealloc ~~", [self class]);
}

@end
