//
//  JKWheelLayout.m
//  CollectionViewCustomerLayout
//
//  Created by Jack on 2017/10/28.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "JKWheelLayout.h"

@interface JKWheelLayout ()

@property (nonatomic,assign,readonly) NSInteger width;
@property (nonatomic,assign,readonly) NSInteger height;
@property (nonatomic,assign,readonly) NSUInteger itemCount;
@property (nonatomic,assign,readonly) CGFloat anglePerItem;
@property (nonatomic,assign,readonly) CGFloat currentOffsetX;
@property (nonatomic,assign,readonly) CGFloat screenCenterX;
@property (nonatomic,assign,readonly) CGFloat circularCenterY;
@property (nonatomic,strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attrArray;

@end

@implementation JKWheelLayout

#pragma mark - Public

- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
    [self invalidateLayout];
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    [self invalidateLayout];
}

#pragma mark - Private

- (CGFloat)anglePerItem {
    /**
     * 围绕圆周均匀分布
     */
//    return 2 * M_PI / self.itemCount;
    
    /**
     * 保证Item间距不会太大，但是间距太小时（Item数量多，radius小）会导致Item重叠
     * Item数量增长，对应的Radius值也应增加
     */
    return atan(self.itemSize.width / self.radius);
}

- (NSInteger)width {
    return self.collectionView.bounds.size.width;
}

- (NSInteger)height {
    return self.collectionView.bounds.size.height;
}

- (NSUInteger)itemCount {
    return [self.collectionView numberOfItemsInSection:0];
}

- (CGFloat)currentOffsetX {
    return self.collectionView.contentOffset.x;
}

- (CGFloat)screenCenterX {
    return self.currentOffsetX + self.width * 0.5;
}

- (CGFloat)circularCenterY {
    /**
     * 0 <= k <= 1： k越大，距离底部越近
     * k > 1: k越大距离底部越远
     */
    float k = 0.9;
    return self.height * k + self.radius;
}

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)attrArray {
    if (!_attrArray) {
        _attrArray = [NSMutableArray array];
    }
    return _attrArray;
}

#pragma mark - Super

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat itemSpace = (self.radius + self.itemSize.height * 0.5) * sinf(self.anglePerItem);
    CGFloat theta = -(self.currentOffsetX / itemSpace) * self.anglePerItem; // 正负控制旋转方向
    
    for (int i = 0; i < self.itemCount; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        x = (self.radius + self.itemSize.height * 0.5) * sinf(theta) + self.screenCenterX;
        y = self.circularCenterY - (self.radius + self.itemSize.height * 0.5) * cosf(theta);
        
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attrs.center = CGPointMake(x, y);
        attrs.size = self.itemSize;
        attrs.transform = CGAffineTransformMakeRotation(theta); // 不旋转就和摩天轮类似
        attrs.zIndex = 1-ABS(sin(theta));
        [self.attrArray addObject:attrs];
        theta += self.anglePerItem;
    }
}

- (CGSize)collectionViewContentSize {
    CGFloat itemSpace = (self.radius + self.itemSize.height * 0.5) * sinf(self.anglePerItem);
    CGFloat w = (self.itemCount - 1) * itemSpace + self.width;
    return CGSizeMake(w, self.collectionView.frame.size.height);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attrArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.attrArray objectAtIndex:indexPath.row];
}

// 返回 true 告知 collectionView 在滑动时布局失效，然后它会调用prepareLayout()
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}



@end
