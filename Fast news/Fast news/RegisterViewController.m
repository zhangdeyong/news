//
//  RegisterViewController.m
//  Fast news
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 ZDY. All rights reserved.
//

#import "RegisterViewController.h"
#import "FMDBModel.h"

@interface RegisterViewController ()

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UITextField *tf;
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) FMDatabaseQueue *queue;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册页面";
    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(done)];
    
    // 设置背景图片
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 603)];
    _imageView.image = [UIImage imageNamed:@"background.png"];
    [self.view addSubview:_imageView];
    
    [self  customView];
    
    // 打开数据库
    self.queue = [FMDBModel shareDB];
}

- (void)customView {
    NSArray *array1 = @[@"账号:", @"密码:", @"确认密码:", @"邮箱:", @"联系方式:"];
    NSArray *array2 = @[@"请输入账号...", @"请输入密码...", @"再次输入密码...", @"请输入邮箱...", @"请输入联系方式..."];
    
    for (int i = 0; i < 5; i++) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(30, 80 + 60 * i, 80, 30)];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.text = array1[i];
        [self.view addSubview:_label];
        
        self.tf = [[UITextField alloc] initWithFrame:CGRectMake(130, 75 + 60 * i, 215, 40)];
        _tf.borderStyle = UITextBorderStyleRoundedRect;
        _tf.placeholder = array2[i];
        _tf.textAlignment = NSTextAlignmentLeft;
        _tf.tag = 1000 + i;
        _tf.clearsOnBeginEditing = YES;
        [self.view addSubview:_tf];
        
        if (i == 1 || i == 2) {
            _tf.secureTextEntry = YES;
        }
    }
    
}

//- (void)back {
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)done {
    UITextField *username = [self.view viewWithTag:1000];
    UITextField *password = [self.view viewWithTag:1001];
    UITextField *surePassword = [self.view viewWithTag:1002];
    UITextField *email = [self.view viewWithTag:1003];
    UITextField *telephone = [self.view viewWithTag:1004];
    
    if (username.text.length != 0 && password.text.length != 0 && [password.text isEqualToString:surePassword.text]) {
        [self.queue inDatabase:^(FMDatabase *db) {
            BOOL reslut = [db executeUpdate:@"insert into userInfo (username, password, email, telephone) values (?, ?, ?, ?);", username.text, password.text, email.text, telephone.text];
            if (reslut) {
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alter addAction:action];
                [self presentViewController:alter animated:YES completion:nil];
                
            } else {
                [self alter:@"注册失败"];
            }
        }];
    } else {
        [self alter:@"账号或密码填写错误"];
    }
   
}


#pragma mark - 提示框

- (void)alter:(NSString *)message {
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
    [alter addAction:action];
    [self presentViewController:alter animated:YES completion:nil];
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

@end
