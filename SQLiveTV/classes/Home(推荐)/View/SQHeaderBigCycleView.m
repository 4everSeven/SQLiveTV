//
//  SQHeaderBigCycleView.m
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/21.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SQHeaderBigCycleView.h"
#import <SDCycleScrollView.h>
#import "SQLiveListItem.h"
#import "SQHeaderBigItem.h"
#import <MJExtension.h>
//推荐界面的大滚动视图
@interface SQHeaderBigCycleView()<SDCycleScrollViewDelegate>
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)SDCycleScrollView *sdcycle;


@end
@implementation SQHeaderBigCycleView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self sdcycle];
    }
    return self;
}

//创建封装好的循环滚动播放页
- (SDCycleScrollView *)sdcycle {
    if(_sdcycle == nil) {
        _sdcycle = [[SDCycleScrollView alloc] initWithFrame:self.bounds];
        [SQWebUtils requestCycleBigItemsWithCompletion:^(id obj) {
            self.array = obj;
            NSMutableArray *imageUrls = [NSMutableArray array];
            NSMutableArray *titleArray = [NSMutableArray array];
            for (SQHeaderBigItem *item in self.array) {
                NSDictionary *link_object = item.link_object;
                SQLiveListItem *listItem = [SQLiveListItem mj_objectWithKeyValues:link_object];
                NSString *url = listItem.thumb;
                [imageUrls addObject:url];
                NSString *title = item.title;
                if (item.title == nil) {
                    title = listItem.title;
                }
                [titleArray addObject:title];
            }
            _sdcycle.imageURLStringsGroup = imageUrls;
            _sdcycle.titlesGroup = titleArray;
            _sdcycle.autoScrollTimeInterval = 2.5;
        
        }];
        _sdcycle.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _sdcycle.delegate = self;

        [self addSubview:_sdcycle];
    }
    return _sdcycle;
}


@end
