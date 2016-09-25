//
//  SQMainTabBarC.m
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/21.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SQMainTabBarC.h"
#import "SQMainNaviC.h"
#import "SQHomeViewController.h"
#import "SQCatagoryViewController.h"
#import "SQLiveViewController.h"
#import "SQMineTableViewController.h"
#import "MineTableViewController.h"

@interface SQMainTabBarC ()

@end

@implementation SQMainTabBarC

-(instancetype)init{
    self = [super init];
    if (self) {
         [self.tabBar setTintColor:MainColor];
        self.tabBar.translucent = NO;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setAllChildControllers];
}

//设置所有的子控制器
-(void)setAllChildControllers{
    //推荐
    SQMainNaviC *homeNavi = [[SQMainNaviC alloc]initWithRootViewController:[SQHomeViewController new]];
    homeNavi.title = @"推荐";
    homeNavi.tabBarItem.image = [UIImage imageNamed:@"推荐_默认"];
    [homeNavi.tabBarItem setSelectedImage:[UIImage imageNamed:@"推荐_焦点"]];
    //栏目
    SQMainNaviC *catNavi = [[SQMainNaviC alloc]initWithRootViewController:[SQCatagoryViewController new]];
    catNavi.title = @"栏目";
    catNavi.tabBarItem.image = [UIImage imageNamed:@"栏目_默认"];
    [catNavi.tabBarItem setSelectedImage:[UIImage imageNamed:@"栏目_焦点"]];
    //直播
    SQMainNaviC *liveNavi = [[SQMainNaviC alloc]initWithRootViewController:[SQLiveViewController new]];
    liveNavi.title = @"直播";
    liveNavi.tabBarItem.image = [UIImage imageNamed:@"发现_默认"];
    [liveNavi.tabBarItem setSelectedImage:[UIImage imageNamed:@"发现_焦点"]];
    //我的
    MineTableViewController *vc = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil]instantiateViewControllerWithIdentifier:@"mine"];
    SQMainNaviC *mineNavi = [[SQMainNaviC alloc]initWithRootViewController:vc];
    mineNavi.title = @"我的";
    mineNavi.tabBarItem.image = [UIImage imageNamed:@"我的_默认"];
    [mineNavi.tabBarItem setSelectedImage:[UIImage imageNamed:@"我的_焦点"]];
    
    [self addChildViewController:homeNavi];
    [self addChildViewController:catNavi];
    [self addChildViewController:liveNavi];
    [self addChildViewController:mineNavi];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
