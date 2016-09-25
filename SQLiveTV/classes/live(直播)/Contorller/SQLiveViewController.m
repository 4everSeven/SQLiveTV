//
//  SQLiveViewController.m
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/21.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SQLiveViewController.h"
#import "SQWebUtils.h"
#import "SQLiveListItem.h"
#import "SQLiveRoomCell.h"
#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import "SQRoomLiveViewController.h"
@interface SQLiveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *MainCollection;
@property(nonatomic,strong)NSMutableArray *itemsArray;
@property(nonatomic,assign)int page;
@property(nonatomic,strong)NSMutableArray *animationImagesArray;
@end

@implementation SQLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    [self setNavi];
    self.page = 1;
    [self setmainCol];
    [self loadData];
   
    //下拉刷新
    __block __weak __typeof(&*self)weakSelf = self;
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    // 设置正在刷新状态的动画图片
    [header setImages:self.animationImagesArray forState:MJRefreshStateRefreshing];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:self.animationImagesArray forState:MJRefreshStatePulling];
    // 设置普通状态的动画图片
    [header setImages:self.animationImagesArray forState:MJRefreshStateIdle];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.MainCollection.mj_header = header;
    [self.MainCollection.mj_header beginRefreshing];

    //上拉加载
    MJRefreshFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    [footer setIgnoredScrollViewContentInsetBottom:64];
   
    self.MainCollection.mj_footer = footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 方法 methods
-(void)setNavi{
    //如果是从栏目中跳转出来的子项目
    if (self.slug) {
        self.title = self.name;
        [self.navigationController.navigationBar setTintColor:NaviTintColor];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_nav_hp_player_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackToCatagory)];
        self.navigationItem.leftBarButtonItem = leftItem;
    }else{
        self.title = @"直播";
    }
}

//跳转回栏目列表
-(void)goBackToCatagory{
    [self.navigationController popViewControllerAnimated:YES];
}

//设置显示的collectionView
-(void)setmainCol{
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = SQMargin;
    layout.minimumInteritemSpacing = SQMargin;
    CGFloat cellWidth = (SQSW - 3 * SQMargin) / 2;
    CGFloat cellHeight = cellWidth * 0.8;
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
    layout.sectionInset = UIEdgeInsetsMake(SQMargin, SQMargin, 0, SQMargin);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
   
    
    //去掉滚动条
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = MainBgColor;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [collectionView registerClass:[SQLiveRoomCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectionView];
    self.MainCollection = collectionView;
}

//加载网络数据
-(void)loadData{
    self.page = 1;
    if (self.slug) {
        [SQWebUtils requestRoomsWithCategory:self.slug andPage:self.page andCompletion:^(id obj) {
            
            self.itemsArray = obj;
            [self.MainCollection reloadData];
            [SVProgressHUD dismiss];
            [self.MainCollection.mj_header endRefreshing];
        }];
    }else{
        [SQWebUtils requestLiveRoomListWithPage:self.page andCompletion:^(id obj) {
            self.itemsArray = obj;
            [self.MainCollection reloadData];
            [SVProgressHUD dismiss];
            [self.MainCollection.mj_header endRefreshing];
        }];
    }
}

//加载更多网络数据
-(void)loadMoreData{
    self.page++;
    if (self.slug) {
        [SQWebUtils requestRoomsWithCategory:self.slug andPage:self.page andCompletion:^(id obj) {
            NSMutableArray *array = self.itemsArray;
            [self.itemsArray addObjectsFromArray:obj];
            [self.MainCollection reloadData];
           // [SVProgressHUD dismiss];
            if (array.count == self.itemsArray.count) {
                 [self.MainCollection.mj_footer endRefreshingWithNoMoreData];
            }else{
                  [self.MainCollection.mj_footer endRefreshing];
            }
        }];
    }else{
        [SQWebUtils requestLiveRoomListWithPage:self.page andCompletion:^(id obj) {
            NSMutableArray *array = self.itemsArray;
            [self.itemsArray addObjectsFromArray:obj];
            [self.MainCollection reloadData];
           // [SVProgressHUD dismiss];
            if (array.count == self.itemsArray.count) {
                [self.MainCollection.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.MainCollection.mj_footer endRefreshing];
            }
        }];
    }
}



#pragma mark - UICollectionDataSource delegateMethods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SQLiveRoomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.item = self.itemsArray[indexPath.row];
    return cell;
}

#pragma mark - UICollection delegateMethods
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SQRoomLiveViewController *vc = [SQRoomLiveViewController new];
    SQLiveListItem *item = self.itemsArray[indexPath.row];
    vc.playUrl = item.playURL;
    vc.uid = item.uid;
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

#pragma mark - 懒加载 lazyLoad
-(NSMutableArray*)animationImagesArray{
    if (_animationImagesArray == nil) {
        _animationImagesArray = [NSMutableArray array];
        for (int i = 0; i < 37; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"bubble_%d",i]];
            [_animationImagesArray addObject:image];
        }
    }
    return _animationImagesArray;
}


@end
