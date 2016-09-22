//
//  SQHeaderReusableView.h
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/22.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQHeaderReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end
