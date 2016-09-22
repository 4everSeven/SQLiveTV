//
//  SQHeaderCycleCell.m
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/22.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SQHeaderCycleCell.h"
#import "SQHeaderBigCycleView.h"
#import "SQHeaderSmallCycleView.h"
@interface SQHeaderCycleCell()
@property(nonatomic,strong)SQHeaderBigCycleView *bigCycleView;
@property(nonatomic,strong)SQHeaderSmallCycleView *smallCycleView;
@end

@implementation SQHeaderCycleCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBigCycle];
        [self setSmallCycle];
    }
    return self;
}

-(void)setBigCycle{
    SQHeaderBigCycleView *bigCycleView = [[SQHeaderBigCycleView alloc]initWithFrame:CGRectMake(0, 0, SQSW, 210)];
    [self addSubview:bigCycleView];
    self.bigCycleView = bigCycleView;
}

-(void)setSmallCycle{
    SQHeaderSmallCycleView *smallCycleView = [[SQHeaderSmallCycleView alloc]initWithFrame:CGRectMake(0, 210, SQSW, 100)];
    [self addSubview:smallCycleView];
    self.smallCycleView= smallCycleView;
}

@end
