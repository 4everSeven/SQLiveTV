//
//  SQHomeViewController.m
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/21.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SQHomeViewController.h"
//#import "SQHeaderBigCycleView.h"
//#import "SQHeaderSmallCycleView.h"
#import "SQHeaderCycleCell.h"
#import "SQHeaderReusableView.h"
#import "SQLiveRoomCell.h"
#import "SQCatagoryViewController.h"
#import "SQLiveViewController.h"
#import "SQListItem.h"
@interface SQHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *mainColletionView;
@property(nonatomic,strong)NSArray *catItems;
@property(nonatomic,strong)NSMutableArray *listItems;
@property(nonatomic,strong)NSDictionary *allData;
@property(nonatomic,assign)int count;
@end

@implementation SQHomeViewController

#pragma mark - 生命周期 lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐";
    self.listItems = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setCol];
    [self loadData];
    //这个用来记录换一换的次数
    self.count = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 方法 methods
-(void)setCol{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
   // layout.sectionInset = UIEdgeInsetsMake(0, SQMargin, 0, SQMargin);
    UICollectionView *mainCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    //mainCollectionView.backgroundColor = [UIColor whiteColor];
    mainCollectionView.backgroundColor = MainBgColor;
    mainCollectionView.showsVerticalScrollIndicator = NO;
    mainCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 108, 0);
    [mainCollectionView registerClass:[SQHeaderCycleCell class] forCellWithReuseIdentifier:@"cycleCell"];
    [mainCollectionView registerClass:[SQLiveRoomCell class] forCellWithReuseIdentifier:@"roomCell"];
    //注册组头
    [mainCollectionView registerNib:[UINib nibWithNibName:@"SQHeaderReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionView"];
    [self.view addSubview:mainCollectionView];
    self.mainColletionView = mainCollectionView;
    
}

-(void)loadData{
    [SQWebUtils requestAllItemWithCompletion:^(NSArray *obj1, NSDictionary *obj2) {
        self.listItems = [obj1 mutableCopy];
        self.allData = obj2;
        [self.mainColletionView reloadData];
    }];
}

//组头的点击事件
-(void)sectionAction:(UIButton *)sender{
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"换一换"]) {
        //重新刷新推荐这一组
        [self.mainColletionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    }else{
        SQListItem *item = self.listItems[sender.tag - 1];
        SQLiveViewController *vc = [SQLiveViewController new];
        vc.slug = item.category_slug;
        vc.name = item.name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UIColletionViewDataSource delegateMethods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    //因为还有一个头部视图
    return self.allData.allKeys.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    if (section==2) {
        return 4;
    }
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SQHeaderCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cycleCell" forIndexPath:indexPath];
        return cell;
    }
    SQLiveRoomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"roomCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    SQListItem *listItem = nil;
    if (self.listItems.count > 0) {
        listItem = self.listItems[indexPath.section - 1];
    }
        NSArray *rooms = [self.allData objectForKey:listItem.slug];
    if (indexPath.section == 1) {
        self.count = self.count > 5?self.count % 6: self.count;
            NSDictionary *dic = rooms[self.count];
            self.count ++;
            NSDictionary *linkDic = dic[@"link_object"];
            SQLiveListItem *item = [SQLiveListItem mj_objectWithKeyValues:linkDic];
            cell.item = item;
        return cell;
    }
else{
    NSDictionary *linkDic = rooms[indexPath.row];
    NSDictionary *link = linkDic[@"link_object"];
    SQLiveListItem *item = [SQLiveListItem mj_objectWithKeyValues:link];
    cell.item = item;
    return cell;
}
   
}

#pragma mark - UICollectoinViewDelegate delegateMethods
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    SQHeaderReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionView" forIndexPath:indexPath];
        view.rightButton.tag = indexPath.section;

        [view.rightButton addTarget:self action:@selector(sectionAction:) forControlEvents:UIControlEventTouchUpInside];
        if (indexPath.section != 0) {
            SQListItem *item = self.listItems[indexPath.section - 1];
            view.titleLabel.text = item.name;
            if ([view.titleLabel.text isEqualToString:@"精彩推荐"]) {
                [view.rightButton setTitle:@"换一换" forState:UIControlStateNormal];
                [view.rightButton setImage:[UIImage imageNamed:@"换一换"] forState:UIControlStateNormal];
            }else{
                [view.rightButton setTitle:@"瞅瞅" forState:UIControlStateNormal];
                [view.rightButton setImage:[UIImage imageNamed:@"栏目_默认"] forState:UIControlStateNormal];
            }
            
        }
        return view;
        
    }
    
    return view;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        return CGSizeMake(0, 40); //宽度无用, 永远与collectionView同宽
    }
    return CGSizeZero;
}

#pragma mark - UICollectionViewFlowLayout delegateMethods
//每个cell的显示大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(SQSW, 210+110);
    }
    float width = (SQSW-3*SQMargin)/2;
    return CGSizeMake(width, width*.8);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section != 0) {
        return UIEdgeInsetsMake(0, SQMargin, 0, SQMargin);
    }
    return UIEdgeInsetsZero;
   }

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return SQMargin;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return SQMargin;
}



@end
