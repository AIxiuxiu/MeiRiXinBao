//
//  BaseLogViewController.m
//  News
//
//  Created by ink on 15/5/11.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "BaseLogViewController.h"

@interface BaseLogViewController ()

@end

@implementation BaseLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logBtn.layer.cornerRadius = 6.0;
//    self.logBtn.layer.borderWidth = 1.0;
    
    self.title = @"登录";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    self.view.backgroundColor = [UIColor whiteColor];
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.labelText = @"loading...";
    _HUD.mode = MBProgressHUDModeAnnularDeterminate;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_neirongxiangqing_1"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    // Do any additional setup after loading the view from its nib.
}

- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_userNameTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logBtnClicked:(id)sender {
    [_userNameTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
    if ([_userNameTF.text isEqualToString:@""]) {
        [self showMsgWithString:@"邮箱不能为空"];
        return;
    }
    if ([_passwordTF.text isEqualToString:@""]) {
        [self showMsgWithString:@"密码不能为空"];
        return;
    }
    if (![self validateEmail:_userNameTF.text]) {
        [self showMsgWithString:@"邮箱填写有误"];
        return;
    }
    if (![self validatePassword:_passwordTF.text]) {
        [self showMsgWithString:@"密码填写有误"];
        return;
    }
   
    if (_manager ) {
        _manager= nil;
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"username":self.userNameTF.text,
                          @"password":self.passwordTF.text};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"username":self.userNameTF.text,
                           @"password":self.passwordTF.text,
                           @"token":token};
    [_HUD show:YES];
    [_manager POST:kLogPass parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_HUD hide:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            NSString *msg = toString([result objectForKey:@"msg"]);
            [self showMsgWithString:msg];
            NSDictionary *dictionary = [result objectForKey:@"data"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"avatar"] forKey:@"headImageStr"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"id"] forKey:@"userId"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"openid"] forKey:@"userOpenId"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"time"] forKey:@"userTime"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"type"] forKey:@"userType"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"username"] forKey:@"userNick"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            NSString *msg = toString([result objectForKey:@"msg"]);
            [self showMsgWithString:msg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES];
        NSLog(@"error:%@",error.description);
    }];
}
- (void) showMsgWithString:(NSString *)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.5];
}
//密码
- (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
//邮箱
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
