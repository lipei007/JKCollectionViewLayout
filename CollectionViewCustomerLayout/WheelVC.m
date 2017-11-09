//
//  WheelVC.m
//  CollectionViewCustomerLayout
//
//  Created by Jack on 2017/11/8.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "WheelVC.h"
#import "JKCoverFlowCell.h"
#import "JKWheelLayout.h"

@interface WheelVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *data;
@property (strong, nonatomic) IBOutlet UICollectionView *cv;
@end

@implementation WheelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.data = [self loadData];
    JKWheelLayout *layout = [[JKWheelLayout alloc] init];
    layout.itemSize = CGSizeMake(200, 256);
    layout.radius = 500;
    self.cv.collectionViewLayout = layout;
    
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
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JKCoverFlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JKCoverFlowCell" forIndexPath:indexPath];
    
    UIImage *img = [self.data objectAtIndex:indexPath.row];
    cell.iv.image = img;
    cell.backgroundColor = [UIColor blueColor];
    [cell setNumber:(int)indexPath.row];
    
    return cell;
}


@end
