//
//  SQLiveListItem.m
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/21.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SQLiveListItem.h"

@implementation SQLiveListItem
-(NSURL *)playURL{
    if (_playURL == nil) {
        _playURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://hls.quanmin.tv/live/%@/playlist.m3u8",self.uid]];

    }
    return _playURL;
}
@end
