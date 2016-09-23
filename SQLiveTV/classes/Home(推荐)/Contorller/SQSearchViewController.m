//
//  SQSearchViewController.m
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/23.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SQSearchViewController.h"
#import "SQLiveRoomCell.h"
#import <SVProgressHUD.h>
#import "SQRoomLiveViewController.h"

@interface SQSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UISearchBarDelegate>
@property (nonatomic, strong)NSMutableArray *itemsArray;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UISearchBar *searchBar;
@end

@implementation SQSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavi];
    [self setCol];
    [self.searchBar becomeFirstResponder];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

//设置导航栏
-(void)setNavi{
    [self.navigationController.navigationBar setTintColor:NaviTintColor];
    //设置左边的返回按键
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_nav_hp_player_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackToLastVC)];
    self.navigationItem.leftBarButtonItem = leftItem;
    //设置右边的搜索按钮
     UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"搜索_默认"] style:UIBarButtonItemStylePlain target:self action:@selector(searchSome)];
    self.navigationItem.rightBarButtonItem = rightButton;
    //设置中间的searchBar
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    searchBar.placeholder = @"请输入主播/房间号";
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.layer.cornerRadius = 14.f;
    searchField.layer.masksToBounds = YES;
    searchField.backgroundColor = [UIColor lightGrayColor];
    searchBar.delegate = self;
    
    self.searchBar = searchBar;
    self.navigationItem.titleView = self.searchBar;
}

//设置collectionView
-(void)setCol{
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
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 108, 0);
    [collectionView registerClass:[SQLiveRoomCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;

}

//加载搜索的网络数据
-(void)loadData{
    //NSLog(@"text:%@",self.searchBar.text);
    [SQWebUtils requestRoomItemsWithName:self.searchBar.text andCallback:^(id obj) {
        self.itemsArray = obj;
        [self.collectionView reloadData];
        [SVProgressHUD dismiss];
    }];
}

//回到之前的界面
-(void)goBackToLastVC{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    
}

//点击搜索按钮之后触发
-(void)searchSome{
    [SVProgressHUD show];
    [self loadData];
    [self.searchBar resignFirstResponder];
}

//当点击键盘上的搜索键之后
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
        [SVProgressHUD show];
        [self loadData];
    [self.searchBar resignFirstResponder];
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SQLiveListItem *item = self.itemsArray[indexPath.row];
    SQRoomLiveViewController *vc = [SQRoomLiveViewController new];
    vc.playUrl = item.playURL;
    [self.navigationController pushViewController:vc animated:YES];
}




@end
