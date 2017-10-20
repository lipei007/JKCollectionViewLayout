//
//  JKStackLayout.m
//  CollectionViewCustomerLayout
//
//  Created by Jack on 2017/6/26.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "JKStackLayout.h"

@interface JKStackLayout ()
{
    NSMutableArray<NSNumber *> *_angle;
}

@end

@implementation JKStackLayout

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSUInteger)itemCount {
    return [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
}

/**
 * 布局首先要提供的信息就是滚动区域大小
 */
- (CGSize)collectionViewContentSize {
    
    return CGSizeZero;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    NSUInteger count = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
//    float angleOffset = M_PI_2 / floor(count / 2);
    float tmpAngle = 0;
    
    _angle = [NSMutableArray array];
    for(int i = 0;i < count; i++) {
        if (i < count /2) {
            [_angle addObject:@(tmpAngle)];
        } else {
            [_angle addObject:@(-tmpAngle)];
        }
        tmpAngle += 0.1;
        if (tmpAngle > 0.5) {
            tmpAngle = 0.1;
        }
    }
}

/**
 * 这个矩形代表了这个视图的可见矩形区域
 * UICollectionViewLayoutAttributes 包含 frame，center，size，transform3D，alpha，zIndex 和 hidden属性。
 * 如果你的布局想要控制其他视图的属性（比如背景颜色），你可以建一个 UICollectionViewLayoutAttributes 的子类，然后加上你自己的属性。
 * 
 * 1、创建一个空的可变数组来存放所有的布局属性。
 * 
 * 2、确定 index paths 中哪些 cells 的 frame 完全或部分位于矩形中。这个计算需要你从 collection view 的数据源中取出你需要显示的数据。
 * 然后在循环中调用你实现的 layoutAttributesForItemAtIndexPath: 方法为每个 index path 创建并配置一个合适的布局属性对象，并将每个对象添加到数组中。
 *
 * 3、如果你的布局包含 supplementary views，计算矩形内可见 supplementary view 的 index paths。
 * 在循环中调用你实现的 layoutAttributesForSupplementaryViewOfKind:atIndexPath: ，并且将这些对象加到数组中。
 * 通过为 kind 参数传递你选择的不同字符，你可以区分出不同种类的supplementary views（比如headers和footers）。
 * 当需要创建视图时，collection view 会将 kind 字符传回到你的数据源。记住 supplementary 和 decoration views 的数量和种类完全由布局控制。
 * 你不会受到 headers 和 footers 的限制。
 *
 * 4、如果布局包含 decoration views，计算矩形内可见 decoration views 的 index paths。
 * 在循环中调用你实现的 layoutAttributesForDecorationViewOfKind:atIndexPath: ，并且将这些对象加到数组中。
 * 
 * 5、返回数组。
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attrs = [NSMutableArray array];
    for (int i = 0; i < [self itemCount]; i++) {
        UICollectionViewLayoutAttributes *layoutAttrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [attrs addObject:layoutAttrs];
    }
    
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = self.collectionView.bounds.size.width;
    CGFloat height = self.collectionView.bounds.size.height;
    CGFloat w = MIN(width, height);
    CGFloat itemSize = sqrt(pow(w, 2) / 2);
    float angle = [[_angle objectAtIndex:indexPath.row] floatValue];
    
    UICollectionViewLayoutAttributes *layoutAttrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    layoutAttrs.size = CGSizeMake(itemSize, itemSize);
    layoutAttrs.center = CGPointMake(width * 0.5, height * 0.5);
    layoutAttrs.transform = CGAffineTransformMakeRotation(angle);
    layoutAttrs.zIndex = [self itemCount] - indexPath.row; // 第一个在最上面
    
    return layoutAttrs;
}

/**
 * Supplementary views 相当于 table view 的 section header 和 footer views。
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

/**
 * Decoration views 纯粹为一个装饰品。他们完全属于布局对象，并被布局对象管理，他们并不从 data source 获取的 contents。
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

/**
 *  CollectionView bounds 改变时，布局需要告诉 collection view 是否需要重新计算布局。
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {

    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(newBounds.size, oldBounds.size)) {
        return YES;
    }
    return NO;
}

@end
