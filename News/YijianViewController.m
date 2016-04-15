//
//  YijianViewController.m
//  Part-time job easy
//
//  Created by ink on 14-8-22.
//  Copyright (c) 2014年 ink. All rights reserved.
//

#import "YijianViewController.h"

@interface YijianViewController ()

@end
@implementation YijianViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    //self.textView.text = @"";
    self.teleTextField.delegate =self;
    self.textView.delegate =self;
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    _HUD.labelText = @"loading...";
    [self.view addSubview:_HUD];
    UIButton *leftButton=[[UIButton alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [leftButton setImage:[UIImage imageNamed:@"icon_neirongxiangqing_1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(previousViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barLeftButton=[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=barLeftButton;
    self.title = @"意见反馈";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    // Do any additional setup after loading the view from its nib.
}
- (void)previousViewController {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
    [self.teleTextField resignFirstResponder];
}
- (IBAction)sendButtonClicked:(id)sender {
    if ([self.teleTextField.text isEqualToString:@""]||[self.textView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self.textView resignFirstResponder];
    [self.teleTextField resignFirstResponder];
    if (_manager) {
        _manager = nil;
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"email":self.teleTextField.text,
                          @"content":self.textView.text};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"email":self.teleTextField.text,
                           @"content":self.textView.text,
                           @"token":token};
    [_HUD show:YES];
    [_manager POST:kFeedBack parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [_HUD hide:YES];
        if ([[result objectForKey:@"ret"]intValue] == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 200;
            [alert show];
        }else  {
            NSString *msg = [result objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES];
        NSLog(@"error:%@,%s",error.description,__FUNCTION__);
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 200) {
        [self previousViewController];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = [self.view frame];
        frame.origin.y-=150;
        self.view.frame =frame;
    }];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = [self.view frame];
        frame.origin.y+=150;
        self.view.frame =frame;
    }];
}
@end
