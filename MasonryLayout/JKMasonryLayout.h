//
//  JKMasonryLayout.h
//  CollectionViewCustomerLayout
//
//  Created by Jack on 2017/7/3.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKMasonryLayout;
@protocol JKMasonryLayoutDelegate <NSObject>

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JKMasonryLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JKMasonryLayout : UICollectionViewLayout

@property (nonatomic,assign) NSUInteger numberOfColumns;
@property (nonatomic,assign) CGFloat interItemSpacing;
@property (nonatomic,weak) id<JKMasonryLayoutDelegate> delegate;

@end
