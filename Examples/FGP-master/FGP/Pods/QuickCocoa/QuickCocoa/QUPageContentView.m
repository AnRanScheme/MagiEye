//
//  QUPageContentView.m
//  QuickUI
//
//  Created by briceZhao on 2018/7/15.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

#import "QUPageContentView.h"
#import "QUPageTitleView.h"

@interface QUPageContentView () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation QUPageContentView

- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs {
    self = [super initWithFrame:frame];
    if (self) {
        self.childVCs = childVCs;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self addSubview: self.collectionView];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kPageContentViewCellId];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childVCs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPageContentViewCellId forIndexPath:indexPath];
    
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    UIViewController *childVC = self.childVCs[indexPath.item];
    
    [cell.contentView addSubview: childVC.view];
    
    return cell;
}

- (void)scrollDidEndScroll {
    NSInteger index = (NSInteger)(self.collectionView.contentOffset.x / self.collectionView.frame.size.width);
    if ([self.delegate respondsToSelector:@selector(pageContentView:didEndScrollToIndex:)]) {
        [self.delegate pageContentView:self didEndScrollToIndex:index];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollDidEndScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self scrollDidEndScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.fromOffsetX = scrollView.contentOffset.x;
    self.isTitleClickForbidSVDelegate = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat toOffsetX = scrollView.contentOffset.x;
    if (self.isTitleClickForbidSVDelegate || self.fromOffsetX == toOffsetX) {
        return;
    }
    
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
    CGFloat progress = 0;
    CGFloat collectionViewWidth = scrollView.bounds.size.width;
    if (toOffsetX > self.fromOffsetX) {
        sourceIndex = (NSInteger)(toOffsetX / collectionViewWidth);
        targetIndex = sourceIndex + 1;
        if (targetIndex >= self.childVCs.count) {
            targetIndex = self.childVCs.count - 1;
            return;
        }
        progress = toOffsetX / collectionViewWidth - floor(toOffsetX/collectionViewWidth);
        if (toOffsetX - self.fromOffsetX == collectionViewWidth) {
            progress = 1.f;
            targetIndex = sourceIndex;
        }
    } else {
        //右划向左侧滚
        if (toOffsetX < 0) {
            return;
        }
        targetIndex = (NSInteger)(toOffsetX/collectionViewWidth);
        sourceIndex = targetIndex + 1;
        if (sourceIndex >= self.childVCs.count) {
            sourceIndex = self.childVCs.count - 1;
        }
        progress = 1 - (toOffsetX/collectionViewWidth - floor(toOffsetX/collectionViewWidth));
        
        //完全划过去
        if (self.fromOffsetX - toOffsetX == collectionViewWidth) {
            progress = 1.f;
            sourceIndex = targetIndex;
        }
    }
    if ([self.delegate respondsToSelector:@selector(pageContentView:sourceIndex:targetIndex:progress:)]) {
        [self.delegate pageContentView:self sourceIndex:sourceIndex targetIndex:targetIndex progress:progress];
    }
}

- (void)pageTitleView:(QUPageTitleView *)titleView targetIndex:(NSInteger)targetIndex {
    self.isTitleClickForbidSVDelegate = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:targetIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath  atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)dealloc {
    NSLog(@"%@ has dealloc ~~", [self class]);
}

@end
