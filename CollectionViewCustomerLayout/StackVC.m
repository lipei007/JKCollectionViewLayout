//
//  StackVC.m
//  CollectionViewCustomerLayout
//
//  Created by Jack on 2017/11/8.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "StackVC.h"
#import "JKStackView.h"

@interface StackVC ()<JKStackViewDelegate>
@property (nonatomic,strong) NSArray *data;
@property (strong, nonatomic) IBOutlet UICollectionView *cv;
@end

@implementation StackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat w = CGRectGetWidth(self.view.bounds);
    CGFloat h = CGRectGetHeight(self.view.bounds);
    
    CGRect frame = CGRectMake((w - 380) * 0.5, (h - 380) * 0.5, 380, 380);
    JKStackView *v = [JKStackView jk_stackViewPhoto:[[self loadData] mutableCopy] withFrame:self.view.bounds];
    v.delegate = self;
    [self.view addSubview:v];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)jk_stackView:(JKStackView *)stackView didSelectImageAtIndex:(NSUInteger)index {
    NSLog(@"select %lu",index);
}

- (void)jk_stackView:(JKStackView *)stackView didShowImageAtIndex:(NSUInteger)index {
    NSLog(@"show %lu",index);
}


- (NSArray *)loadData {
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 1; i < 7; i++) {
        NSString *name = [NSString stringWithFormat:@"00%d.jpeg",i];
        UIImage *img = [UIImage imageNamed:name];
        [arr addObject:img];
    }
    
    return arr;
}


@end
