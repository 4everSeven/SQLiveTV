//
//  SQCatCell.h
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/21.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQCatCellItem.h"
@interface SQCatCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *iconIV;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic, strong)SQCatCellItem *item;
@end
