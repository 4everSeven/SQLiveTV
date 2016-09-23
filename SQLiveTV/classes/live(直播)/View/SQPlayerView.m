//
//  SQPlayerView.m
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/23.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SQPlayerView.h"

@implementation SQPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

@end
