//
//  JKCardLayout.m
//  CollectionViewCustomerLayout
//
//  Created by Jack on 2017/10/25.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "JKCardLayout.h"

@implementation JKCardLayout
{
    CGFloat _itemWidth,_itemHeight;
    NSMutableArray *_itemAttributesArray;
}

- (NSUInteger)itemNumber {
    if (self.collectionView.dataSource) {
        return [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    }
    return 0;
}

- (CGFloat)collectionViewWidth {
    CGFloat w = self.collectionView.bounds.size.width;
    return w;
}

- (CGFloat)collectionViewHeight {
    CGFloat h = self.collectionView.bounds.size.height;
    return h;
}

- (void)prepareLayout {
    CGFloat w = self.collectionView.bounds.size.width;
    CGFloat h = self.collectionView.bounds.size.height;
    
    CGFloat size = MIN(w, h);
    
    _itemWidth = size * 0.5;
    _itemHeight = size * 0.8;
    
    _itemAttributesArray = [NSMutableArray arrayWithCapacity:[self itemNumber]];
    
}

- (CGFloat)margin {
    CGFloat margin = ([self collectionViewWidth] - _itemWidth) * 0.5;
    return margin;
}

- (CGFloat)interval {
    return [self margin] * 0.5;
}

- (CGSize)collectionViewContentSize {
    CGFloat margin = [self margin];
    CGFloat interval = [self interval];
    return CGSizeMake((interval + _itemWidth) * [self itemNumber] + interval + margin, 0);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (int i = 0; i < [self itemNumber]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        if (CGRectIntersectsRect(rect, attr.frame)) {

            CGFloat centerX = [self collectionViewWidth] * 0.5 + self.collectionView.contentOffset.x;
            CGFloat space = ABS(attr.center.x - centerX);
            CGFloat scale = 1 - space / [self collectionViewWidth];
            attr.transform = CGAffineTransformMakeScale(scale, scale);
            attr.zIndex = -space;

            [tmpArr addObject:attr];
        }
        
    }
    
    return tmpArr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attr = nil;
    
    attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // frame
    CGFloat margin = [self margin];
    CGFloat interval = [self interval];
    attr.frame = CGRectMake(margin + (_itemWidth + interval) * indexPath.row, ([self collectionViewHeight] - _itemHeight) * 0.5, _itemWidth, _itemHeight);

    return attr;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;//最终要停下来的X
    rect.size = self.collectionView.frame.size;
    
    //获得计算好的属性
    NSArray *attsArray = [self layoutAttributesForElementsInRect:rect];
    //计算collection中心点X
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width / 2;
    
    CGFloat minSpace = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in attsArray) {
        
        if (ABS(minSpace) > ABS(attrs.center.x - centerX)) {
            minSpace = attrs.center.x - centerX;
        }
    }
    // 修改原有的偏移量
    proposedContentOffset.x += minSpace;
    return proposedContentOffset;
}

// YES 每次视图刷新都重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    CGRect oldBounds = self.collectionView.bounds;
//    if (CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
//        return NO;
//    }
    return YES;
}

@end
