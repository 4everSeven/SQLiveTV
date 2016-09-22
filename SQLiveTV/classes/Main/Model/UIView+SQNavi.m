//
//  UIView+SQNavi.m
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/22.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "UIView+SQNavi.h"

@implementation UIView (SQNavi)
//获取view的navi
- (UINavigationController *)naviController{
    
    UIResponder *responder = self;
    
    while ((responder = [responder nextResponder]))
        
        if ([responder isKindOfClass: [UINavigationController class]])
            
            return (UINavigationController *)responder;
    
    //如果没有发现，那么return nil
    return nil;
}
@end
