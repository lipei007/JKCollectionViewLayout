//
//  ViewController.m
//  CollectionViewCustomerLayout
//
//  Created by Jack on 2017/6/26.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "ViewController.h"
#import "JKStackView.h"
#import "JKCoverFlowCell.h"
#import "JKCoverFlowLayout.h"
#import "JKMasonryLayout.h"
#import "JKCardLayout.h"

@interface ViewController ()<JKStackViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,JKMasonryLayoutDelegate>

@property (nonatomic,strong) NSArray *data;
@property (strong, nonatomic) IBOutlet UICollectionView *cv;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

   
    CGFloat w = CGRectGetWidth(self.view.bounds);
    CGFloat h = CGRectGetHeight(self.view.bounds);

//    CGRect frame = CGRectMake((w - 380) * 0.5, (h - 380) * 0.5, 380, 380);
//    JKStackView *v = [JKStackView jk_stackViewPhoto:[[self loadData] mutableCopy] withFrame:self.view.bounds];
//    v.delegate = self;
//    [self.view addSubview:v];
    
    
//    self.data = [self loadData];
//    JKCoverFlowLayout *layout = [[JKCoverFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(1000, 1000);
//    self.cv.collectionViewLayout = layout;

//    self.data = [self loadData];
//    JKMasonryLayout *layout = [[JKMasonryLayout alloc] init];
//    layout.numberOfColumns = 3;
//    layout.interItemSpacing = 10;
//    layout.delegate = self;
//    self.cv.collectionViewLayout = layout;
    
    
    self.data = [self loadData];
    JKCardLayout *layout = [[JKCardLayout alloc] init];
    self.cv.collectionViewLayout = layout;
}

- (void)jk_stackView:(JKStackView *)stackView didSelectImageAtIndex:(NSUInteger)index {
    NSLog(@"select %lu",index);
}

- (void)jk_stackView:(JKStackView *)stackView didShowImageAtIndex:(NSUInteger)index {
    NSLog(@"show %lu",index);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
//    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JKCoverFlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JKCoverFlowCell" forIndexPath:indexPath];
    
    UIImage *img = [self.data objectAtIndex:indexPath.row];
    cell.iv.image = img;

//    cell.backgroundColor = [UIColor brownColor];
//    cell.lb.text = [NSString stringWithFormat:@"%lu",indexPath.row];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JKMasonryLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % 2 == 0) {
        return 100;
    } else {
        return 50;
    }
    
}

@end
