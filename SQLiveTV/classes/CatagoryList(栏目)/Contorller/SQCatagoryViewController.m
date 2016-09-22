//
//  SQCatagoryViewController.m
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/21.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SQCatagoryViewController.h"
#import "SQCatCellItem.h"
#import "SQCatCell.h"
#import <SVProgressHUD.h>
#import "SQLiveViewController.h"
@interface SQCatagoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *MainCollection;
@property(nonatomic,strong)NSMutableArray *itemsArray;
@end

@implementation SQCatagoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    self.title = @"栏目";
    [self setmainCol];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 方法 methods
//设置显示的collectionView
-(void)setmainCol{
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = SQMargin;
    layout.minimumInteritemSpacing = SQMargin;
    CGFloat cellWidth = (SQSW - 4 * SQMargin) / 3;
    CGFloat cellHeight = cellWidth * 1.5;
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    //去掉滚动条
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = MainBgColor;
    collectionView.contentInset = UIEdgeInsetsMake(SQMargin, SQMargin, 64, SQMargin);
    [collectionView registerClass:[SQCatCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectionView];
    self.MainCollection = collectionView;
}

//加载网络数据
-(void)loadData{
    [SQWebUtils requestCatItemsWithCompletion:^(id obj) {
        self.itemsArray = obj;
        [self.MainCollection reloadData];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - UICollectionDataSource delegateMethods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SQCatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.item = self.itemsArray[indexPath.row];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.layer.shadowOffset = CGSizeMake(0, 2);
    cell.layer.shadowOpacity = 0.80;
    return cell;
}

#pragma mark - UICollection delegateMethods
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SQCatCellItem *item = self.itemsArray[indexPath.row];
    SQLiveViewController *vc = [SQLiveViewController new];
    vc.slug = item.slug;
    vc.name = item.name;
    [self.navigationController pushViewController:vc animated:YES];
}

//是否支持旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

//只支持竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}






@end
