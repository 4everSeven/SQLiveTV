//
//  SQRoomLiveViewController.m
//  SQLiveTV
//
//  Created by 王思齐 on 16/9/23.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SQRoomLiveViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SQPlayerView.h"
@interface SQRoomLiveViewController ()
@property(nonatomic,strong)AVPlayerLayer *layer;
@property(nonatomic,strong)AVPlayerItem *webItem;
@property(nonatomic,strong)UIButton *swithchButton;
@property(nonatomic,strong)SQPlayerView *playerView;
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,assign)CATransform3D myTransform;

@end

@implementation SQRoomLiveViewController



- (void)viewDidLoad {
    [super viewDidLoad];

   [self setToPlay];
    //[self creatPlayerConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
   // [self.navigationController setNavigationBarHidden:YES];
    self.tabBarController.tabBar.hidden = YES;
}

//判断横竖屏情况
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //判断设备 是否是横屏
    if ([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft||[UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        self.layer.frame = CGRectMake(0, 20, SQSW, SQSH);
    }else{
        self.layer.frame = CGRectMake(0, 0, SQSW, 200);
    }
}

#pragma mark - 方法 methods

//播放
-(void)setToPlay{

    //创建网络地址的播放项
    AVPlayerItem *webItem = [AVPlayerItem playerItemWithURL:self.playUrl];
    
        self.webItem = webItem;
        //添加监听事件
        [self.webItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //创建播放器对象
    AVPlayer *player = [AVPlayer playerWithPlayerItem:webItem];
    
    //创建播放的layer
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    
    layer.frame = CGRectMake(0, 20, SQSW, 200);
    //设置填充模式
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //把播放layer 添加到界面中
    [self.view.layer addSublayer:layer];
    
    self.layer = layer;
    [player play];
    self.view.backgroundColor = [UIColor whiteColor];
}



-(void)creatPlayerConfig{


    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.swithchButton = button;
    self.swithchButton.frame = CGRectMake(SQSW-44,SQSW*9/16-10 , 44, 44);
    [self.swithchButton setTitle:@"sssss" forState:UIControlStateNormal];
    [self.swithchButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.swithchButton setTintColor:[UIColor whiteColor]];
    self.swithchButton.titleLabel.font = [UIFont systemFontOfSize:14];
   // [self.swithchButton addTarget:self action:@selector(switchToChangeFrame) forControlEvents:UIControlEventTouchUpInside];
    [self.swithchButton setImage:[UIImage imageNamed:@"movie_fullscreen"] forState:UIControlStateNormal];
    [self.view addSubview:self.swithchButton];
    UIView *sssview = [[UIView alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    sssview.backgroundColor = [UIColor redColor];
    [self.view addSubview:sssview];
}



// KVO方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSLog(@"loading");
    }
}

- (void)dealloc {
    [self.webItem removeObserver:self forKeyPath:@"status" context:nil];
}








@end
