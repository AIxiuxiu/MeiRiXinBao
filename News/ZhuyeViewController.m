//
//  ZhuyeViewController.m
//  News
//
//  Created by ink on 15/1/16.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "ZhuyeViewController.h"

@interface ZhuyeViewController ()
{
    NSString *_userId;
    UITextField *_textField;
    UIImage *image;
    NSString *imageStr;
}
@end

@implementation ZhuyeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    _HUD.labelText = @"loading...";
    [self.view addSubview:_HUD];
    _userId = [USER_DEFAULT objectForKey:@"userId"];
    self.navigationController.navigationBar.translucent = NO;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.borderColor = [[UIColor clearColor] CGColor];
    self.headImageView.layer.cornerRadius = 6.0;
    self.headImageView.layer.borderWidth = 1.0;
    
    
    NSString *imgStr = [NSString stringWithFormat:@"%@",[USER_DEFAULT objectForKey:@"headImageStr"]];
    NSString *nick = [NSString stringWithFormat:@"%@",[USER_DEFAULT objectForKey:@"userNick"]];
    [self.headImageView setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"icon_youbianlan_1.png"]];
    self.nickLabel.text = nick;
    
    
    self.title = @"个人主页";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_neirongxiangqing_1"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nickViewClicked)];
    [self.nickView addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headViewClicked)];
    [self.headView addGestureRecognizer:tap2];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 手势
- (void)nickViewClicked {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改昵称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.delegate = self;
    [alertView show];
}
- (void)headViewClicked {
    if (!_sheet) {
        _sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册中选择", nil];
        _sheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    }
    [_sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        NSLog(@"相机");
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else if(buttonIndex == 1) {
        NSLog(@"相册");
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        [self presentViewController:pickerImage animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"info = %@",info);
    
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(postImage) object:nil];
    [thread start];
}
#pragma mark - 上传图片
- (void)postImage {
    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    imageStr = [GTMbase64 stringByEncodingData:data];
    //    imageStr = [imageStr stringByReplacingOccurrencesOfString:<#(NSString *)#> withString:<#(NSString *)#>]
    if (_manager) {
        _manager = nil;
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"user_id":_userId,
                          @"avatar":imageStr};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"user_id":_userId,
                           @"avatar":imageStr,
                           @"token":token};
    [_HUD show:YES];
    [_manager POST:kchangeUserImage parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_HUD hide:YES];
        NSLog(@"result = %@",responseObject);
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            NSDictionary *dataDic = [result objectForKey:@"data"];
            [self displayNotification:nil titleStr:@" 修改头像成功 " Duration:0.8 time:0.2];
            [USER_DEFAULT setObject:[dataDic objectForKey:@"url"] forKey:@"headImageStr"];
            [self.headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"url"]]] placeholderImage:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
        }else {
            [self displayNotification:nil titleStr:@"修改头像失败" Duration:0.8 time:0.2];
        }
        //        [USER_DEFAULT setObject:[dictionary objectForKey:@"avatar"] forKey:@"headImageStr"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES];
        NSLog(@"error:%@",error.description);
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *textFeild = [alertView textFieldAtIndex:0];
        if (![textFeild.text isEqualToString:@""]) {
            //上传昵称,上传完成需要修改当前页面的昵称，userDefault
            NSLog(@"text = %@",textFeild.text);
            if (_manager) {
                _manager = nil;
            }
            _manager = [AFHTTPRequestOperationManager manager];
            _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
            _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSDictionary *dic = @{@"user_id":_userId,
                                  @"username":textFeild.text};
            NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
            NSDictionary *dict = @{@"user_id":_userId,
                                   @"username":textFeild.text,
                                   @"token":token};
            [_HUD show:YES];
            [_manager POST:kChangeNick parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [_HUD hide:YES];
                NSLog(@"result = %@",responseObject);
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([[result objectForKey:@"ret"] intValue] == 1) {
                    [self displayNotification:nil titleStr:@" 修改昵称成功 " Duration:0.8 time:0.2];
                    [USER_DEFAULT setObject:textFeild.text forKey:@"userNick"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                    self.nickLabel.text = textFeild.text;
                }else {
                    [self displayNotification:nil titleStr:@"修改昵称失败" Duration:0.8 time:0.2];
                }
                //        [USER_DEFAULT setObject:[dictionary objectForKey:@"avatar"] forKey:@"headImageStr"];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [_HUD hide:YES];
                NSLog(@"error:%@",error.description);
            }];

            
        }
    }
}

- (void)backButtonClicked {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)logoutBtnClicked:(id)sender {
    [USER_DEFAULT setObject:nil forKey:@"headImageStr"];
    [USER_DEFAULT setObject:nil forKey:@"userId"];
    [USER_DEFAULT setObject:nil forKey:@"userOpenId"];
    [USER_DEFAULT setObject:nil forKey:@"userTime"];
    [USER_DEFAULT setObject:nil forKey:@"userType"];
    [USER_DEFAULT setObject:nil forKey:@"userNick"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutSuccess" object:nil];
    [self backButtonClicked];
}

#pragma mark 提示
- (void)displayNotification:(NSString *)imageStr  titleStr:(NSString *)title Duration:(float)Duration time:(float)time
{
    //Duration展示之间 time消失动画时间
    BDKNotifyHUD *notify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:imageStr] text:title];
    CGFloat centerX= self.view.bounds.size.width/2;
    CGFloat centerY= self.view.bounds.size.height/2;
    notify.center = CGPointMake(centerX ,centerY);
    [self.view addSubview:notify];
    [notify presentWithDuration:Duration speed:time inView:self.view completion:^{
        [notify removeFromSuperview];
    }];
}
@end
