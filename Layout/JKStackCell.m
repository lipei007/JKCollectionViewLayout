//
//  MyCell.m
//  CollectionViewCustomerLayout
//
//  Created by Jack on 2017/6/26.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "JKStackCell.h"

@interface JKStackCell ()

@property (nonatomic,strong) UIImageView *iv;

@end

@implementation JKStackCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.iv = [[UIImageView alloc] initWithFrame:self.bounds];
        self.iv.userInteractionEnabled = YES;
        [self addSubview:self.iv];
        
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    
    self.iv.image = image;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iv.frame = self.bounds;
    
}

    

@end
