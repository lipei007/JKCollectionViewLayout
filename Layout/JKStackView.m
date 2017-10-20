//
//  JKStackView.m
//  CollectionViewCustomerLayout
//
//  Created by Jack on 2017/6/27.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "JKStackView.h"
#import "JKStackLayout.h"
#import "JKStackCell.h"


@interface JKStackView ()<UICollectionViewDataSource,UICollectionViewDelegate,CAAnimationDelegate>
{
    NSArray *originData;
}
@property (nonatomic,strong) UICollectionView *cv;
@property (nonatomic,strong) NSMutableArray *data;



@end


@implementation JKStackView

+ (instancetype)jk_stackViewPhoto:(NSArray<UIImage *> *)photos withFrame:(CGRect)frame {
    JKStackView *stack = [[JKStackView alloc] initWithFrame:frame];
    stack->originData = photos;
    stack.data = [photos mutableCopy];
    return stack;
}

- (void)setUp {
    JKStackLayout *layout = [[JKStackLayout alloc] init];
    
    self.cv = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.cv.dataSource = self;
    self.cv.delegate = self;
    self.cv.clipsToBounds = NO;
    self.clipsToBounds = NO;
    self.cv.backgroundColor = [UIColor clearColor];
    [self.cv registerClass:[JKStackCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:self.cv];
}

// 拦截用户交互
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setUp];
        
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.cv.frame = self.bounds;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JKStackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImage *img = [self.data objectAtIndex:indexPath.row];
    [cell setImage:img];
    
    if (indexPath.row == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(jk_stackView:didShowImageAtIndex:)]) {
            NSUInteger index = [self->originData indexOfObject:img];
            [self.delegate jk_stackView:self didShowImageAtIndex:index];
        }
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jk_stackView:didSelectImageAtIndex:)]) {
        UIImage *image = [self.data objectAtIndex:indexPath.row];
        NSUInteger index = [self->originData indexOfObject:image];
        [self.delegate jk_stackView:self didSelectImageAtIndex:index];
    }
}


float   jk_stack_zPosition;
bool    jk_stack_effect = NO;
CGPoint jk_stack_startP;
CGRect  jk_stack_frame;

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    JKStackCell *cell = (JKStackCell *)[self.cv cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    cell.layer.zPosition = jk_stack_zPosition;
    
    UIImage *img = [self.data objectAtIndex:0];
    [self.data removeObject:img];
    [self.data addObject:img];
    
    [self.cv reloadData];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint cur = [touch locationInView:self];
    
    jk_stack_startP = cur;
    JKStackCell *cell = (JKStackCell *)[self.cv cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    jk_stack_frame = cell.frame;
    
    jk_stack_effect = YES;

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (jk_stack_effect) {
        UITouch *touch = [touches anyObject];
        CGPoint cur = [touch locationInView:self];

        CGFloat offsetX = cur.x - jk_stack_startP.x;
        CGFloat offsetY = cur.y - jk_stack_startP.y;
        
        
        JKStackCell *cell = (JKStackCell *)[self.cv cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        // 使用transform position动画会没有
//        cell.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, offsetX, offsetY);
        
        CGRect tmpFrame = jk_stack_frame;
        tmpFrame.origin.x += offsetX;
        tmpFrame.origin.y += offsetY;
        cell.frame = tmpFrame;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (jk_stack_effect) {
        jk_stack_effect = NO;
        UITouch *touch = [touches anyObject];
        CGPoint cur = [touch locationInView:self];
        
        CGFloat offsetX = cur.x - jk_stack_startP.x;
        CGFloat offsetY = cur.y - jk_stack_startP.y;
        // 有效点击,touch.tapCount == 1
        if ((fabs(offsetX) < 1 && fabs(offsetX) >= 0) && (fabs(offsetY) < 1 && fabs(offsetY) >= 0)) {
            [self collectionView:self.cv didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            return;
        }
        
        
        JKStackCell *cell = (JKStackCell *)[self.cv cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        jk_stack_zPosition = cell.layer.zPosition;
        
        
        
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        // 有效的移动
        if (fabs(offsetX) < 0.3 * width && fabs(offsetY) < height * 0.3) {
            
            [UIView animateWithDuration:0.3 animations:^{
                cell.frame = jk_stack_frame;
            }];
            
        } else {
            cell.layer.zPosition = -1;
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.cv.bounds) * 0.5, CGRectGetHeight(self.cv.bounds) * 0.5)];
            animation.duration = 0.3;
            animation.removedOnCompletion = YES;
            animation.delegate = self;
            [cell.layer addAnimation:animation forKey:@"position"];
        }
        
        
    }
}


@end
