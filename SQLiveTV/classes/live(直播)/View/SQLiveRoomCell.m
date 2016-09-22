//
//  SQLiveRoomCell.m
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/21.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SQLiveRoomCell.h"

@implementation SQLiveRoomCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIView *bgView =[[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-50, frame.size.width, 20)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = .6;
        [self.contentView addSubview:bgView];
        self.bgView = bgView;
    }
    return self;
}

-(UIImageView *)roomIV{
    
    if (!_roomIV) {
        
        _roomIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-30)];
        [self.contentView insertSubview:_roomIV atIndex:0];
    }
    return _roomIV;
}

-(UIButton *)userNameBtn{
    if (!_userNameBtn) {
        _userNameBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2 , 20)];
        [self.bgView addSubview:_userNameBtn];
        
        [_userNameBtn setImage:[UIImage imageNamed:@"主播名"] forState:UIControlStateNormal];
        _userNameBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _userNameBtn;
}

-(UIButton *)userCountBtn{
    if (!_userCountBtn) {
        _userCountBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width/2 , 0, self.bounds.size.width/2 , 20)];
        [self.bgView addSubview:_userCountBtn];
        [_userCountBtn setImage:[UIImage imageNamed:@"观看人数"] forState:UIControlStateNormal];
        _userCountBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _userCountBtn;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-30, self.bounds.size.width, 30)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        
    }
    return _nameLabel;
}

-(void)setItem:(SQLiveListItem *)item{
    _item = item;
    self.nameLabel.text = item.title;
    [self.roomIV sd_setImageWithURL:[NSURL URLWithString:item.thumb] placeholderImage:LoadingImage];
    [self.userNameBtn setTitle:item.nick forState:UIControlStateNormal];
    float viewNumber = item.view.floatValue;
    float viewCount = viewNumber > 10000? viewNumber / 10000.0 : viewNumber;
    NSString *str = viewNumber > 10000? [NSString stringWithFormat:@"%.1f万",viewCount]:item.view;
    [self.userCountBtn setTitle:str forState:UIControlStateNormal];
    
}
@end
