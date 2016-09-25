//
//  MineTableViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/8/30.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "MineTableViewController.h"
#import "HFStretchableTableHeaderView.h"
#import "SignInViewController.h"

@interface MineTableViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameOrOtherLabel;
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic,strong)HFStretchableTableHeaderView *hfStretchView;
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@end

@implementation MineTableViewController

#pragma mark - 生命周期 lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏的按钮和标题
    UIBarButtonItem *leftBT = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrowLeft-gray-32"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackToLastVC)];
    self.navigationItem.leftBarButtonItem = leftBT;
    self.title = @"我的";
    
    
    //设置headerView的拉伸效果
    self.hfStretchView = [HFStretchableTableHeaderView new];
    [self.hfStretchView stretchHeaderForTableView:self.tableView withView:self.headerView];
    
    //去掉分割线左边的空白
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //计算缓存
    [[SDImageCache sharedImageCache]calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        self.cacheLabel.text = [NSString stringWithFormat:@"当前缓存：%.2fM",totalSize / 1024.0 /1024];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alertShow:)];
    [self.headerView addGestureRecognizer:tap];

    if ([BmobUser currentUser]) {
        BmobUser *user = [BmobUser currentUser];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
        self.nameOrOtherLabel.text = [user objectForKey:@"username"];
        
    
       // [self.headerView addGestureRecognizer:tap];
    }else{
        self.headerImageView.image = [UIImage imageNamed:@"avator"];
        self.nameOrOtherLabel.text = @"登录体验更多功能";
       // [self.headerView removeGestureRecognizer:tap];
    }
    self.tap = tap;
    
     //计算缓存
    [[SDImageCache sharedImageCache]calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        self.cacheLabel.text = [NSString stringWithFormat:@"当前缓存：%.2fM",totalSize / 1024.0 /1024];
    }];
}

-(void)alertShow:(UITapGestureRecognizer *)tap{
    if ([BmobUser currentUser] == nil) {
        SignInViewController *vc = [SignInViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"登出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [BmobUser logout];
            self.headerImageView.image = [UIImage imageNamed:@"avator"];
            self.nameOrOtherLabel.text = @"登录体验更多功能";
            if (self.headerView.gestureRecognizers.count > 0) {
                [self.headerView removeGestureRecognizer:tap];
            }
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            nil;
        }];
        [ac addAction:action1];
        [ac addAction:action2];
        [self presentViewController:ac animated:YES completion:nil];
    }
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate
//这样设置的原因是为了让headerView和下面的section留出一部分的空白
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 9;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

//设置cell的高度而60
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//去掉分割线左边的空白
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//section的头部和底部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SQSW, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SQSW, 1)];
    view.backgroundColor = [UIColor clearColor];
    //[view autoresizingMask];
    return view;
}

//按下后松手要动画取消高亮
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //如果点击了清除缓存的话，执行下面这段代码
    if (indexPath.section == 1 && indexPath.row) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除缓存么？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //清除内存缓存
            [[SDImageCache sharedImageCache]clearMemory];
            //清除磁盘缓存
            [[SDImageCache sharedImageCache]clearDisk];
            //计算缓存
            [[SDImageCache sharedImageCache]calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
                self.cacheLabel.text = [NSString stringWithFormat:@"当前缓存：%.2fM",totalSize / 1024.0 /1024];
            }];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            nil;
        }];
        [ac addAction:action1];
        [ac addAction:action2];
        [self presentViewController:ac animated:YES completion:nil];
    }
}

#pragma mark - stretchableTable delegate（必须要实现）
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.hfStretchView scrollViewDidScroll:scrollView];
}

- (void)viewDidLayoutSubviews
{
    [self.hfStretchView resizeView];
}

#pragma mark - 方法 methods
//回到上一个视图
-(void)goBackToLastVC{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
