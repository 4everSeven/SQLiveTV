//
//  SQWebUtils.m
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/21.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SQWebUtils.h"
#import <AFNetworking.h>
#import "SQCatCellItem.h"
#import "SQLiveListItem.h"
#import "SQHeaderBigItem.h"
#import "SQListItem.h"
@implementation SQWebUtils
//获取栏目的网络数据
+(void)requestCatItemsWithCompletion:(Block)block{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *requstUrl = @"http://www.quanmin.tv/json/categories/list.json";
    
    [manager GET:requstUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *response = responseObject;
        NSArray *itemsArray = [SQCatCellItem mj_objectArrayWithKeyValuesArray:response];
        block(itemsArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}


//获取直播列表里的网络数据
+(void)requestLiveRoomListWithPage:(int)page andCompletion:(Block)block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *requestUrl = [NSString stringWithFormat:@"http://www.quanmin.tv/json/play/list_%d.json",page];
    if (page==1) {
         requestUrl = [requestUrl stringByReplacingOccurrencesOfString:@"_1" withString:@""];
    }
    [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = responseObject[@"data"];
        NSArray *itemsArray = [SQLiveListItem mj_objectArrayWithKeyValuesArray:dataArray];
        block(itemsArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}

//点击栏目后出现的直播列表
+(void)requestRoomsWithCategory:(NSString *)slug andPage:(int)page andCompletion:(Block)block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *requestUrl = [NSString stringWithFormat:@"http://www.quanmin.tv/json/categories/%@/list_%d.json",slug,page];
    if (page==1) {
        requestUrl = [requestUrl stringByReplacingOccurrencesOfString:@"list_1" withString:@"list"];
    }
    [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSArray *dataArray = responseObject[@"data"];
            NSArray *itemsArray = [SQLiveListItem mj_objectArrayWithKeyValuesArray:dataArray];
            block(itemsArray);
        }        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
         block(nil);
    }];
}

//大的轮播图
+(void)requestCycleBigItemsWithCompletion:(Block)block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *requestUrl = @"http://www.quanmin.tv/json/page/app-index/info.json";
    [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *index = responseObject[@"mobile-index"];
        NSArray *cycleItems = [SQHeaderBigItem mj_objectArrayWithKeyValuesArray:index];
        block(cycleItems);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}

//获取推荐见面SectionHeader的数据
+(void)requestSectionHeaderItemsWithCompletion:(Block)block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *requestUrl = @"http://www.quanmin.tv/json/page/app-index/info.json";
   [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       NSArray *listArray = [SQListItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
       block(listArray);
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"error:%@",error);
   }];
}

//获取推荐界面的所有数据
+(void)requestAllItemWithCompletion:(BBlock)block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *requestUrl = @"http://www.quanmin.tv/json/page/app-index/info.json";
    [manager GET:requestUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // block(responseObject);
        NSMutableArray *listItems = [NSMutableArray array];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSArray *array = [SQListItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        for (SQListItem *item in array) {
            if (![item.name isEqualToString:@"APP-首页轮播"]) {
                if (![item.name isEqualToString:@"APP-明星"]) {
                    NSArray *arr = responseObject[item.slug];
                    [listItems addObject:item];
                    [dic setObject:arr forKey:item.slug];
                }
            }
        }
        block(listItems,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}


@end
