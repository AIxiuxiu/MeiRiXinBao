//
//  ResignViewController.m
//  News
//
//  Created by ink on 15/5/11.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "ResignViewController.h"

@interface ResignViewController ()

@end

@implementation ResignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.registerBtn.layer.cornerRadius = 6.0;
//    self.registerBtn.layer.borderWidth = 1.0;
    
    self.title = @"注册";
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_userNameTF resignFirstResponder];
    [_passWordTF resignFirstResponder];
    [_againPasswordTF resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)resignBtnClicked:(id)sender {
    [_userNameTF resignFirstResponder];
    [_passWordTF resignFirstResponder];
    [_againPasswordTF resignFirstResponder];
    if ([_userNameTF.text isEqualToString:@""]) {
        [self showMsgWithString:@"邮箱不能为空"];
        return;
    }
    if ([_passWordTF.text isEqualToString:@""]) {
        [self showMsgWithString:@"密码不能为空"];
        return;
    }
    if (![self validateEmail:_userNameTF.text]) {
        [self showMsgWithString:@"邮箱填写有误"];
        return;
    }
    if (![self validatePassword:_passWordTF.text]) {
        [self showMsgWithString:@"密码填写有误"];
        return;
    }
    if (![self.passWordTF.text isEqualToString:self.againPasswordTF.text]) {
        [self showMsgWithString:@"两次密码输入不一致"];
        return;
    }
    if (_manager ) {
        _manager= nil;
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"username":self.userNameTF.text,
                          @"password":self.passWordTF.text};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"username":self.userNameTF.text,
                           @"password":self.passWordTF.text,
                           @"token":token};
    [_HUD show:YES];
    [_manager POST:kRegister parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_HUD hide:YES];
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
//            NSString *msg = toString([result objectForKey:@"msg"]);
            NSDictionary *dictionary = [result objectForKey:@"data"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"avatar"] forKey:@"headImageStr"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"id"] forKey:@"userId"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"openid"] forKey:@"userOpenId"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"time"] forKey:@"userTime"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"type"] forKey:@"userType"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"username"] forKey:@"userNick"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];

        }else {
            NSString *msg = toString([result objectForKey:@"msg"]);
            [self showMsgWithString:msg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES];
        NSLog(@"error:%@",error.description);
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
