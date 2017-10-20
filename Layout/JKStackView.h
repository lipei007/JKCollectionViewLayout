//
//  JKStackView.h
//  CollectionViewCustomerLayout
//
//  Created by Jack on 2017/6/27.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKStackView;
@protocol JKStackViewDelegate <NSObject>

- (void)jk_stackView:(JKStackView *)stackView didSelectImageAtIndex:(NSUInteger)index;

- (void)jk_stackView:(JKStackView *)stackView didShowImageAtIndex:(NSUInteger)index;

@end

@interface JKStackView : UIView

+ (instancetype)jk_stackViewPhoto:(NSArray<UIImage *> *)photos withFrame:(CGRect)frame;

@property (nonatomic,weak) id<JKStackViewDelegate> delegate;

@end
