//
//  SQLiveRoomCell.h
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/21.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiveListItem.h"
@interface SQLiveRoomCell : UICollectionViewCell
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIImageView *roomIV;
@property (nonatomic, strong)UIButton *userNameBtn;
@property (nonatomic, strong)UIButton *userCountBtn;
@property (nonatomic, strong)UIView *bgView;
@property(nonatomic,strong)SQLiveListItem *item;
@end
