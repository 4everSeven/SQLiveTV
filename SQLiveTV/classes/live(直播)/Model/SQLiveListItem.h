//
//  SQLiveListItem.h
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/21.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiveListItem : NSObject

@property (nonatomic, copy) NSString *default_image;
@property (nonatomic, copy) NSString *slug;
@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *category_name;
@property (nonatomic, strong) NSNumber *hidden;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *category_slug;
@property (nonatomic, strong) NSURL *recommend_image;
@property (nonatomic, copy) NSString *play_at;
@property (nonatomic, copy) NSString *app_shuffling_image;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *announcement;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *grade;
//@property (nonatomic, strong) NSURL *thumb;
@property(nonatomic,copy)NSString *thumb;
@property (nonatomic, copy) NSString *create_at;
@property (nonatomic, copy) NSString *video_quality;
@property (nonatomic, strong) NSURL *avatar;
@property (nonatomic, copy) NSString *view;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, strong) NSNumber * follow;
@property (nonatomic, strong)NSURL *playURL;
@end
