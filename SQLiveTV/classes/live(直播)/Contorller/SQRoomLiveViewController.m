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
#import <RongIMLib/RongIMLib.h>
@interface SQRoomLiveViewController ()<UITableViewDelegate,UITableViewDataSource,RCIMClientReceiveMessageDelegate>
@property(nonatomic,strong)AVPlayerItem *webItem;
@property(nonatomic,strong)UIButton *swithchButton;
@property(nonatomic,strong)SQPlayerView *playerView;
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,assign)CATransform3D myTransform;
@property(nonatomic,strong)AVPlayerViewController *avPlayerVC;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIActivityIndicatorView *indicatorView;
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSMutableArray *messagesArray;
@property(nonatomic,strong)RCIMClient *rcimClient;
@property(nonatomic,strong)UIView *bottomView;
//按到评论按钮出现的视图
@property(nonatomic,strong)UIView *commentView;
@property(nonatomic,strong)UITextField *TF;
@property(nonatomic,strong)UIButton *commentButton;
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
    self.messagesArray = [NSMutableArray array];
    [self setMainTable];
    [self jionTalkGroup];
    [self receiveMassege];
    NSLog(@"chatRommId:%@",self.uid);
    [self setBottom];
    [self setupCommentView];
    self.mainTableView.allowsSelection = NO;
    self.mainTableView.separatorStyle = NO;
    //对键盘进行监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeKeyboard:) name:UIKeyboardWillChangeFrameNotification object:nil];
    

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
    self.mainTableView.alpha = 1;
    self.bottomView.alpha = 1;
    self.commentButton.alpha = 1;
    
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
    self.mainTableView.alpha = 0;
    self.bottomView.alpha = 0;
    self.commentButton.alpha = 0;
    
    
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

//设置下面的聊天
-(void)setMainTable{
    UITableView *tableViwe = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playerView.frame), SQSW, SQSH - self.playerView.frame.size.height) style:UITableViewStylePlain];
    tableViwe.delegate = self;
    tableViwe.dataSource = self;
    tableViwe.backgroundColor = [UIColor whiteColor];
    [tableViwe registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableViwe];
    self.mainTableView = tableViwe;
}

//加入直播聊天室
-(void)jionTalkGroup{
    //self.rcimClient = [RCIMClient sharedRCIMClient];
    
    [[RCIMClient sharedRCIMClient] joinChatRoom:self.uid messageCount:10 success:^{
        NSLog(@"加入聊天室成功");
        //NSLog(@"chatRommId:%@",self.uid);
        
    } error:^(RCErrorCode status) {
        
        NSLog(@"加入聊天直播室error:%ld",status);
    }];
    
}

//接收到消息
-(void)receiveMassege{
    [self.rcimClient setReceiveMessageDelegate:self object:nil];
}

-(void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object{
    if ([message isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *text = (RCTextMessage *)message.content;
        NSString *messageStr = [NSString stringWithFormat:@"%@说：%@",message.senderUserId,text.content];
        NSLog(@"%@",messageStr);
        [self.messagesArray addObject:messageStr];
        [self.mainTableView reloadData];
    }
}

-(void)setBottom{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SQSH - 104, SQSW, 40)];
    bottomView.backgroundColor = MainBgColor;
    //[self.view addSubview:bottomView];
    self.bottomView = bottomView;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
   // [button setTitle:@"大家好" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"弹幕_按下"] forState:UIControlStateNormal];
    button.tintColor = MainColor;
    //button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(SQSW/2, 0, 40, 40);
    button.center = bottomView.center;
    [button addTarget:self action:@selector(gotoComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
//    NSLog(@"self.view.x:%f,self.view.y:%f,widtg:%f,height:%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
//    NSLog(@"button.x:%f,.y:%f,width:%f,height:%f",button.frame.origin.x,button.frame.origin.y,button.frame.size.width,button.frame.size.height);
    self.commentButton = button;
}

//设置评论视图
-(void)setupCommentView{
    UIView *commentView = [[UIView alloc]initWithFrame:CGRectMake(0, SQSH, SQSW, 40)];
    commentView.backgroundColor = [UIColor whiteColor];
    UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, SQSW - 100, 30)];
    textF.placeholder = @"发布评论（少于100字）";
    [commentView addSubview:textF];
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sendButton.frame = CGRectMake(SQSW - 55, 5, 50, 30);
    [sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [commentView addSubview:sendButton];
    [self.view addSubview:commentView];
    self.TF = textF;
    self.commentView = commentView;
    //self.commentView.backgroundColor = [UIColor redColor];
    self.commentView.userInteractionEnabled = YES;
}

-(void)sendComment{
    [self.view endEditing:YES];
   
}

-(void)gotoComment{
    [self.TF becomeFirstResponder];
    NSLog(@"执行了");
}

#pragma mark - 键盘通知方法 methodsForKeyBoard

-(void)changeKeyboard:(NSNotification*)notification{
    NSDictionary *dic = notification.userInfo;
    CGRect keyBoardframe = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    
    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[dic[UIKeyboardAnimationCurveUserInfoKey] longValue] animations:^{
        
        CGRect comframe = self.commentView.frame;
        comframe.origin.y = keyBoardframe.origin.y - 104;
        
        if (keyBoardframe.origin.y == SQSH) {
            comframe.origin.y = SQSH;
        }
        
        NSLog(@"keyb:%f",keyBoardframe.origin.y);
        NSLog(@"orin.y:%f",comframe.origin.y);
        self.commentView.frame = comframe;
        
        
        //通过动画，修改约束
        [self.view layoutIfNeeded];
    } completion:nil];
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

//让电池条消失
-(BOOL)prefersStatusBarHidden{
    if (self.playerView.frame.size.height > 500) {
        return YES;
    }
    return NO;
}

- (void)dealloc {
    [self.webItem removeObserver:self forKeyPath:@"status" context:nil];
}

#pragma mark - UITableViewDataSource delegateMethods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messagesArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    cell.textLabel.text = self.messagesArray[indexPath.row];
    return cell;
}






@end
