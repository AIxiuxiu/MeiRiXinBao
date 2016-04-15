//
//  Disclose ViewController.m
//  News
//
//  Created by ink on 15/1/15.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "DiscloseViewController.h"
#import "AssetHelper.h"
@interface DiscloseViewController ()
{
    DoImagePickerController *cont;
    NSInteger numOfPhotos;
}
@end

@implementation DiscloseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pics = [[NSMutableArray alloc] init];
    self.textView.delegate = self;
    _aIVs = @[_firstBtn,_secondBtn,_thirdBtn,_fourthBtn,_fifthBtn,_sixBtn];
    numOfPhotos = 0;
    [self UIConfig];
    if (_isHelp) {
        self.textView.text = @"说点什么吧...";
    }else {
        self.textView.text = @"来点爆料吧...";
    }
    
    {
        UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        listBtn.frame = CGRectMake(0, 0, 60, 30);
        [listBtn addTarget:self action:@selector(listBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        NSString *btnTitle;
        if (_isHelp) {
            btnTitle = @"我的求助";
        }else {
            btnTitle = @"我的爆料";
        }
        listBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [listBtn setTitle:btnTitle forState:UIControlStateNormal];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:listBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - rightItemClick
- (void)listBtnClicked {
    NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
    if (!userId) {
        LoginViewController *log = [[LoginViewController alloc] init];
        BaseNavigationController *nav =[[BaseNavigationController alloc] initWithRootViewController:log];
        log.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    MyDiscloseViewController *vc = [[MyDiscloseViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - textView代理
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"来点爆料吧..."]||[textView.text isEqualToString:@"说点什么吧..."]) {
        textView.text = @"";
    }
}
#pragma mark - 创建UI
- (void)UIConfig {
    if (self.isHelp == YES) {
        self.title = @"发表求助";
    }else {
        self.title = @"发表爆料";
    }
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_neirongxiangqing_1"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
    _toolBar.barStyle = UIBarStyleBlack;
    _toolBar.translucent = YES;
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneBtnClicked)];
    NSArray *array = @[spaceItem,doneItem];
    [_toolBar setItems:array];
    self.textView.inputAccessoryView = _toolBar;
    
    [_firstBtn  addTarget:self action:@selector(picBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_secondBtn addTarget:self action:@selector(picBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_thirdBtn  addTarget:self action:@selector(picBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_fourthBtn addTarget:self action:@selector(picBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_fifthBtn  addTarget:self action:@selector(picBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_sixBtn    addTarget:self action:@selector(picBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)backButtonClicked {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)doneBtnClicked {
    [self.textView resignFirstResponder];
}
#pragma mark - 点击添加图片
- (void)picBtnClicked:(UIButton *)button {
    if (numOfPhotos > button.tag-500) {
        return;
    }
    if (!_sheet) {
        _sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册中选择", nil];
        _sheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    }
    [_sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    if (buttonIndex == 0) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        
//        picker.editing = YES;
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else if (buttonIndex == 1) {
//        if (!cont) {
//            cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
//            cont.delegate = self;
//            cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
//            cont.nMaxCount = 6;
//            cont.nColumnCount = 4;
//            cont.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        }
        if (cont) {
            cont = nil;
        }
        cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
        cont.delegate = self;
        cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
        cont.nMaxCount = 6-numOfPhotos;
        cont.nColumnCount = 4;
        cont.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:cont animated:YES completion:nil];
    }
}

#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [_pics addObjectsFromArray:aSelected];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
    {
        for (int i = 0; i <aSelected.count; i++)
        {
            UIButton *btn = [_aIVs objectAtIndex:numOfPhotos];
            btn.hidden = NO;
            [btn setBackgroundImage:[aSelected objectAtIndex:i] forState:UIControlStateNormal];
            numOfPhotos++;
        }
//        numOfPhotos += aSelected.count;
        if (numOfPhotos > 5) {
            return;
        }
       UIButton *button = [_aIVs objectAtIndex:numOfPhotos];
        button.hidden = NO;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"info = %@",info);
    UIButton *button = [_aIVs objectAtIndex:numOfPhotos];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    CGSize imagesize = image.size;
    imagesize.height = 800;
    imagesize.width = 600;
    //对图片大小进行压缩--
    
    image = [self imageWithImage:image scaledToSize:imagesize];
//     NSData *imageData = UIImageJPEGRepresentation(image,0.7);
//    image = [UIImage imageWithData:imageData];
    
    [_pics addObject:image];
    numOfPhotos +=1;
    if (numOfPhotos > 5) {
        return;
    }
    button = [_aIVs objectAtIndex:numOfPhotos];
    button.hidden = NO;
}

//对图片的尺寸处理
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)postBtnClicked:(id)sender {
    
    //先判断是否登录
    NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
    if (!userId) {
        LoginViewController *log = [[LoginViewController alloc] init];
        BaseNavigationController *nav =[[BaseNavigationController alloc] initWithRootViewController:log];
        log.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    if ([self.textView.text isEqualToString:@"来点爆料吧..."]||[self.textView.text isEqualToString:@"说点什么吧..."]||[self.textView.text isEqualToString:@""]) {
        [self  displayNotification:nil titleStr:@"写点什么吧！" Duration:0.8 time:0.2];
        return;
    }
    //登录后进行图片的准备
    NSString *picStr;
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc] init];//参数的字典
    if (_pics.count ==0) {
        picStr = @"";
    }else{
        NSMutableArray *picStrs = [[NSMutableArray alloc] init];
        for (UIImage *image in _pics) {
            NSData *data = UIImageJPEGRepresentation(image, 0.3);
            NSString * imageStr = [GTMbase64 stringByEncodingData:data];
            [picStrs addObject:imageStr];
        }
        picStr = [picStrs componentsJoinedByString:@","];
        /////
        for (int i=0; i<picStrs.count; i++) {
            NSString *keyStr = [NSString stringWithFormat:@"picture%d",i+1];
            [parDic setObject:[picStrs objectAtIndex:i] forKey:keyStr];
        }
        /////
    }
    if (parDic.count == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"来张图片吧";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.5];
        return;
    }
    //那种类型：求助还是爆料
    NSString *type;
    if (_isHelp) {
        //求助
        type = @"2";
    }else {
        //爆料
        type = @"1";
    }
    //最后进行网络请求
    if (_manager) {
        _manager = nil;
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userId forKey:@"user_id"];
    [dic setValuesForKeysWithDictionary:parDic];
    [dic setObject:self.textView.text forKey:@"text"];
    [dic setObject:type forKey:@"type"];
//    NSDictionary *dic = @{@"user_id":userId,
//                          @"picture":picStr,
//                          @"text":self.textView.text,
//                          @"type":type};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValuesForKeysWithDictionary:dic];
    [dict setObject:token forKey:@"token"];
//    NSDictionary *dict = @{@"user_id":userId,
//                           @"picture":picStr,
//                           @"text":self.textView.text,
//                           @"type":type,
//                           @"token":token};
    if (!_HUD) {
        _HUD  = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
    }
    [_HUD show:YES];
    [_manager POST:kHelpOrBao parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"result = %@",responseObject);
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [_HUD hide:YES];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发表成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else {
            [self displayNotification:nil titleStr:@"发表失败" Duration:0.8 time:0.2];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES];
        NSLog(@"error = %@",error.description);
    }];
}
#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self backButtonClicked];
    }
}
#pragma mark - 提示
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
