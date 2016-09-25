//
//  SignUpViewController.m
//  MP
//
//  Created by 王思齐 on 16/8/23.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SignUpViewController.h"
#import <BmobSDK/Bmob.h>
@interface SignUpViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property(nonatomic)NSData *imageData;
@end

@implementation SignUpViewController

#pragma mark - 生命周期 lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.signUpButton.backgroundColor = MainColor;
    //不隐藏导航栏
    self.navigationController.navigationBarHidden = NO;
    self.title = @"注册";
    //设置手势事件，当手指点到头像时可以更换头像
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeaderIVToChange:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 方法 methods
//当手指点到头像时,更换头像
-(void)tapHeaderIVToChange:(UITapGestureRecognizer*)sender{
    CGPoint point = [sender locationInView:self.view];
    //如果触摸点在头像内的话
    if (CGRectContainsPoint(self.headerIV.frame, point)) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"确定更换头像么" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            nil;
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *vc = [[UIImagePickerController alloc]init];
            vc.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
        }];
        [ac addAction:action1];
        [ac addAction:action2];
        [self presentViewController:ac animated:YES completion:nil];
    }
}

//点击注册按钮后
- (IBAction)clickedToSignUp:(UIButton*)sender {
    BmobUser *bUser = [[BmobUser alloc]init];
    [bUser setUsername:self.userNameTF.text];
    [bUser setPassword:self.passwordTF.text];
    [bUser setEmail:self.emailTF.text];
    //如果设置了头像
    if (self.imageData) {
        //上传图片 得到图片地址
        [BmobFile filesUploadBatchWithDataArray:@[@{@"filename":@"abc.jpg",@"data":self.imageData}] progressBlock:^(int index, float progress) {
            NSLog(@"进度：%d-%f",index,progress);
        } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //得到上传完成的图片地址
                BmobFile *file = [array firstObject];
                NSString *headPath = file.url;
                //把图片地址作为用户的头像 保存
                [bUser setObject:headPath forKey:@"headPath"];
                [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"注册成功");
                        //[self.navigationController popViewControllerAnimated:YES];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
            }
        }];
    }else{
        NSString *path = [[NSBundle mainBundle]pathForResource:@"avator" ofType:@"png"];
        //NSLog(@"path:%@",path);
        [BmobFile filesUploadBatchWithPaths:@[path] progressBlock:^(int index, float progress) {
            NSLog(@"进度：%d-%f",index,progress);
        } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //得到上传完成的图片地址
                BmobFile *file = [array firstObject];
                NSString *headPath = file.url;
                //把图片地址作为用户的头像 保存
                [bUser setObject:headPath forKey:@"headPath"];
                [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"注册成功");
                        //[self.navigationController popViewControllerAnimated:YES];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
            }
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *imageURLPath = [[info objectForKey:UIImagePickerControllerReferenceURL] description];
    if ([imageURLPath hasSuffix:@"PNG"]) {
        self.imageData = UIImagePNGRepresentation(image);
    }else{//jpg
        //后面的数字代表压缩率 0-1为不压缩
        self.imageData = UIImageJPEGRepresentation(image, .5);
        
    }
    self.headerIV.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
