//
//  SQRoomLiveViewController.m
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/23.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SQRoomLiveViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "SQPlayerView.h"
@interface SQRoomLiveViewController ()
@property(nonatomic,strong)AVPlayerItem *webItem;
@property(nonatomic,strong)UIButton *swithchButton;
@property(nonatomic,strong)SQPlayerView *playerView;
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,assign)CATransform3D myTransform;
@property(nonatomic,strong)AVPlayerViewController *avPlayerVC;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIActivityIndicatorView *indicatorView;
@end

@implementation SQRoomLiveViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setTopV];
    [self setToPlay];
    [self creatPlayerConfig];
    [self setTopV];
    
    [self setIndicator];
    [self.indicatorView startAnimating];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    //[self.navigationController setNavigationBarHidden:YES];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - 方法 methods
//设置topView用来返回
-(void)setTopV{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SQSH, 44)];
    [self.view addSubview:topView];
    self.topView = topView;
    CATransform3D transform = CATransform3DMakeRotation(M_PI / 2, 0, 0, 1.0);
    self.topView.layer.transform = transform;
    self.topView.center  = CGPointMake(SQSW-24, self.view.center.y);
    self.topView.hidden=YES;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 20, 40, 40);
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.tintColor = [UIColor whiteColor];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"返回_默认"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(justGoBack) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:leftButton];
}

//点击返回之后回到小屏状态
-(void)justGoBack{
    _playerView.frame = CGRectMake(0, 0, SQSW * 9 /16, SQSW);
    self.topView.hidden=YES;
    
    [UIView animateWithDuration:0.3 animations:^{
    
        _playerView.layer.transform  = self.myTransform  ;
        self.swithchButton.alpha =0 ;
        _playerView.center  = CGPointMake(SQSW/2, SQSW * 9 /16/2);
        
        
    } completion:^(BOOL finished) {
        _playerView.center = self.view.center;
        self.swithchButton.alpha =1;
        self.swithchButton.hidden=NO;
        _playerView.center  = CGPointMake(SQSW/2, SQSW * 9 /16/2);
        self.navigationController.navigationBarHidden=NO;
    }];
}

//播放
-(void)setToPlay{
    self.playerView = [[SQPlayerView alloc]initWithFrame:CGRectMake(0, 0, SQSW, SQSW * 9 /16)];
    [self.view addSubview:_playerView];
    self.webItem = [AVPlayerItem playerItemWithURL:self.playUrl];
    [self.webItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听
    self.player = [AVPlayer playerWithPlayerItem:self.webItem];
    self.playerView.player = _player;
    self.playerView.backgroundColor = [UIColor blackColor];
    self.myTransform = self.playerView.layer.transform;
    [self.playerView.player play];
}

//加载进入全屏的按钮
-(void)creatPlayerConfig{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.swithchButton = button;
    self.swithchButton.frame = CGRectMake(SQSW-44,SQSW*9/16-40 , 44, 44);
    [self.swithchButton setTitle:@"sssss" forState:UIControlStateNormal];
    [self.swithchButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.swithchButton setTintColor:[UIColor whiteColor]];
    self.swithchButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.swithchButton addTarget:self action:@selector(switchToChangeFrame) forControlEvents:UIControlEventTouchUpInside];
    [self.swithchButton setImage:[UIImage imageNamed:@"movie_fullscreen"] forState:UIControlStateNormal];
    [self.view addSubview:self.swithchButton];

}

//进入全屏的方法
- (void)switchToChangeFrame{
    _playerView.frame = CGRectMake(0, 0, SQSH, SQSW);
    _swithchButton.hidden=YES;
    
    self.navigationController.navigationBarHidden=YES;
    [UIView animateWithDuration:0.3 animations:^{
        CATransform3D transform = CATransform3DMakeRotation(M_PI / 2, 0, 0, 1.0);
        
        _playerView.layer.transform  =  transform;
        _playerView.center = self.view.center;
        self.topView.alpha=0;

        
        
    } completion:^(BOOL finished) {
       // _playerView.center = self.view.center;
        _playerView.center = self.view.center;
        _playerView.frame = CGRectMake(0, 0, SQSW, SQSH);
        self.topView.alpha=1;
        self.topView.hidden=NO;
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

//设置菊花
-(void)setIndicator{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [indicator setCenter:self.playerView.center];
    [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView = indicator;
    [self.view addSubview:self.indicatorView];
}


// KVO方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
            UILabel *failedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
            failedLabel.text = @"加载失败";
            failedLabel.textColor = [UIColor whiteColor];
            failedLabel.center = self.playerView.center;
            [self.view addSubview:failedLabel];
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSLog(@"loading");
       
    }
}

-(BOOL)prefersStatusBarHidden{
    if (self.playerView.frame.size.height > 500) {
        return YES;
    }
    return NO;
}

- (void)dealloc {
    [self.webItem removeObserver:self forKeyPath:@"status" context:nil];
}








@end
