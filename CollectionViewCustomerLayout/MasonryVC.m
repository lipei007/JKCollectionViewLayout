//
//  MasonryVC.m
//  CollectionViewCustomerLayout
//
//  Created by Jack on 2017/11/8.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "MasonryVC.h"
#import "JKCoverFlowCell.h"
#import "JKMasonryLayout.h"

@interface MasonryVC ()<UICollectionViewDelegate,UICollectionViewDataSource,JKMasonryLayoutDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *cv;
@end

@implementation MasonryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    JKMasonryLayout *layout = [[JKMasonryLayout alloc] init];
    layout.numberOfColumns = 3;
    layout.interItemSpacing = 10;
    layout.delegate = self;
    self.cv.collectionViewLayout = layout;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JKCoverFlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JKCoverFlowCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor blueColor];
    [cell setNumber:(int)indexPath.row];
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JKMasonryLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % 2 == 0) {
        return 200;
    } else if (indexPath.row % 3 == 0){
        return 300;
    } else {
        return 80;
    }
    
}

@end
