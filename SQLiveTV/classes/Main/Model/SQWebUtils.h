//
//  SQWebUtils.h
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/21.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^Block) (id obj);
typedef void(^BBlock) (NSArray *obj1,NSDictionary *obj2);
@interface SQWebUtils : NSObject
//获取栏目的网络数据
+(void)requestCatItemsWithCompletion:(Block)block;
//获取直播列表里的网络数据
+(void)requestLiveRoomListWithPage:(int)page andCompletion:(Block)block;
//点击栏目后出现的直播列表
+(void)requestRoomsWithCategory:(NSString *)slug andPage:(int)page andCompletion:(Block)block;
//大的轮播图
+(void)requestCycleBigItemsWithCompletion:(Block)block;
//获取推荐界面SectionHeader的数据
+(void)requestSectionHeaderItemsWithCompletion:(Block)block;
//获取推荐界面的所有数据
+(void)requestAllItemWithCompletion:(BBlock)block;
//获取搜索的结果
+(void)requestRoomItemsWithName:(NSString *)name andCallback:(Block)block;
@end
