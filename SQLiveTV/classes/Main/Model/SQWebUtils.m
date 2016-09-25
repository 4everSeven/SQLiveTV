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
#import <CommonCrypto/CommonDigest.h>

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
        NSLog(@"获取栏目的网络数据error:%@",error);
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
        NSLog(@"获取直播列表的网络数据error:%@",error);
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
        NSLog(@"点击栏目后出现的直播列表error:%@",error);
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
        NSLog(@"大的轮播图error:%@",error);
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
       NSLog(@"获取推荐界面的SectionHeadererror:%@",error);
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
        NSLog(@"获取界面所有数据error:%@",error);
    }];
}

//获取搜索的结果
+(void)requestRoomItemsWithName:(NSString *)name andCallback:(Block)block{
    int page = 0;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *requestUrl = @"http://www.quanmin.tv/api/v1";
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"site.search" forKey:@"m"];
    [params setObject:@"2" forKey:@"os"];
    [params setObject:@"0" forKey:@"p[categoryId]"];
    [params setObject:name forKey:@"p[key]"];
    [params setObject:@(page) forKey:@"p[page]"];
    [params setObject:@"20" forKey:@"p[size]"];
    [params setObject:@"1.3.2" forKey:@"v"];
    
    [manager POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSArray *array = [SQLiveListItem mj_objectArrayWithKeyValuesArray:dic[@"data"][@"items"]];
        block(array);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取搜索数据error:%@",error);
        block(nil);
    }];

}

//sha1 加密

- (NSString *) sha1:(NSString *)input
{
    //const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}










@end
