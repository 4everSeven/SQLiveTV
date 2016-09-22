//
//  SQHeaderSmallCycleView.m
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/21.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SQHeaderSmallCycleView.h"
#import "SQCatCellItem.h"
#import "SQLiveViewController.h"
#import "UIView+SQNavi.h"
//不需要做循环滚动的特效
@interface SQHeaderSmallCycleView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *items;

@end
@implementation SQHeaderSmallCycleView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setcol];
        [self loadData];
    }
    return self;
}

//创建collectionView
-(void)setcol{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(50, self.bounds.size.height - 30);
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 20;
    layout.sectionInset = UIEdgeInsetsMake(-10, 10, 0, 10);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

//加载数据
-(void)loadData{
    [SQWebUtils requestCatItemsWithCompletion:^(id obj) {
        self.items = obj;
        [self.collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDataSource delegateMethods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //将这个限定死
    return 8;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    //cell.contentView.backgroundColor = [UIColor grayColor];
    
    UIImageView *iv = [cell viewWithTag:1];
    if (!iv) {
        iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.width)];
        [cell addSubview:iv];
        iv.layer.cornerRadius = cell.bounds.size.width/2;
        iv.layer.masksToBounds = YES;
        iv.tag = 1;
    }
    UILabel *titleLaebl = [cell viewWithTag:2];
    
    if (!titleLaebl) {
        titleLaebl = [[UILabel alloc]initWithFrame:CGRectMake(0,cell.bounds.size.width, cell.bounds.size.width, 20)];
        titleLaebl.tag = 2;
        titleLaebl.font = [UIFont systemFontOfSize:12];
        titleLaebl.textColor = [UIColor lightGrayColor];
        titleLaebl.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:titleLaebl];
    }

    SQCatCellItem *item = self.items[indexPath.row];
    titleLaebl.text = item.name;
    [iv sd_setImageWithURL:[NSURL URLWithString:item.thumb] placeholderImage:LoadingImage];
    
    return cell;
}

#pragma mark - UICollectionView delegateMethods
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SQCatCellItem *item = self.items[indexPath.row];
    SQLiveViewController *vc = [SQLiveViewController new];
    vc.slug = item.slug;
    vc.name = item.name;
    [[self naviController]pushViewController:vc animated:YES];
}


@end
