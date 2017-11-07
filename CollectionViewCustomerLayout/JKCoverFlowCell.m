//
//  JKCoverFlowCell.m
//  CollectionViewCustomerLayout
//
//  Created by Jack on 2017/6/30.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "JKCoverFlowCell.h"

@implementation JKCoverFlowCell

- (void)setNumber:(int)number {
    self.lb.text = [NSString stringWithFormat:@"%d",number];
}

@end
