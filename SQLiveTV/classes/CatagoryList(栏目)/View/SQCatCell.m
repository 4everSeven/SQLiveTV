//
//  SQCatCell.m
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/21.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SQCatCell.h"

@implementation SQCatCell

- (UILabel *)titleLb {
    if(_titleLb == nil) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-30, self.bounds.size.width, 30)];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLb];
    }
    return _titleLb;
}

- (UIImageView *)iconIV {
    if(_iconIV == nil) {
        _iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-30)];
        [self.contentView addSubview:_iconIV];
    }
    return _iconIV;
}


-(void)setItem:(SQCatCellItem *)item{
    _item = item;
    self.titleLb.text = item.name;
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:item.thumb] placeholderImage:LoadingImage];
    
}


@end
