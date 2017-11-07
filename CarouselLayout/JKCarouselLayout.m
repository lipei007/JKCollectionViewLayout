//
//  JKCarouselLayout.m
//  CollectionViewCustomerLayout
//
//  Created by Jack on 2017/10/26.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "JKCarouselLayout.h"

@implementation JKCarouselLayout
{
    CGFloat _interval;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    _interval = 10.f;
    
}

- (NSUInteger)itemNumber {
    if (self.collectionView.dataSource) {
        return [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    }
    return 0;
}

- (CGFloat)collectionViewWith {
    return self.collectionView.bounds.size.width;
}

- (CGFloat)collectionViewHeight {
    return self.collectionView.bounds.size.height;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake([self collectionViewWith] * [self itemNumber] + _interval * ([self itemNumber] - 1), 0);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < [self itemNumber]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [arr addObject:attr];
        }
    }
    
    return arr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat x = ([self collectionViewWith] + _interval) * indexPath.row;

    attr.frame = CGRectMake(x, 0, [self collectionViewWith], [self collectionViewHeight]);
    return attr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
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

@end
