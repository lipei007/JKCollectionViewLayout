//
//  JKMasonryLayout.m
//  CollectionViewCustomerLayout
//
//  Created by Jack on 2017/7/3.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "JKMasonryLayout.h"

@implementation JKMasonryLayout {
    CGFloat maxY;
    NSArray *attrs;
}

- (void)prepareLayout {
    /**
     * 布局过程之前被调用
     * 在此方法中计算边框，numberOfColumns 和 interItemSpacing 决定宽度，高度由代理决定
     *
     */
    [super prepareLayout];
    
    maxY = 0;
    NSUInteger numberOfItem = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    NSMutableArray *attrsArr = [NSMutableArray arrayWithCapacity:numberOfItem];
    
    CGFloat colY[self.numberOfColumns];
    
    for (int i = 0; i < self.numberOfColumns; i++) {
        colY[i] = 0;
    }
    
    for (int i = 0; i < numberOfItem; i++) {
//        int row = i / self.numberOfColumns;
        int col = i % self.numberOfColumns;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGFloat fullWidth = self.collectionView.bounds.size.width;
        CGFloat availableSpaceExcludingPadding = fullWidth - self.interItemSpacing * (self.numberOfColumns + 1);
        CGFloat itemWidth = availableSpaceExcludingPadding / self.numberOfColumns;
        CGFloat itemHeight = [self.delegate collectionView:self.collectionView layout:self heightForItemAtIndexPath:indexPath];
        
        CGFloat x = self.interItemSpacing + (itemWidth + self.interItemSpacing) * col;
        CGFloat y = self.interItemSpacing + colY[col];
        
        CGRect frame = CGRectMake(x, y, itemWidth, itemHeight);
        maxY = CGRectGetMaxY(frame) > maxY ? CGRectGetMaxY(frame) : maxY;
        colY[col] = CGRectGetMaxY(frame);
        
        UICollectionViewLayoutAttributes *itemAttrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        itemAttrs.frame = frame;
        [attrsArr addObject:itemAttrs];
    }
    attrs = attrsArr;
    maxY += self.interItemSpacing;
    
}

- (CGSize)collectionViewContentSize {
    
    return CGSizeMake(self.collectionView.frame.size.width, maxY);
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    __block NSMutableArray *attrsArr = [NSMutableArray array];
    [attrs enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, obj.frame)) {
            [attrsArr addObject:obj];
        }
    }];
    
    return attrsArr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *itemtAttrs = [self->attrs objectAtIndex:indexPath.row];
    return itemtAttrs;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(newBounds.size, oldBounds.size)) {
        return YES;
    }
    return NO;
}

@end
