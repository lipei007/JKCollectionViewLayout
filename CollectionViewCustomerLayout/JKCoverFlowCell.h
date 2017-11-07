//
//  JKCoverFlowCell.h
//  CollectionViewCustomerLayout
//
//  Created by Jack on 2017/6/30.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKCoverFlowCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iv;
@property (strong, nonatomic) IBOutlet UILabel *lb;

- (void)setNumber:(int)number;

@end
