//
//  LandingViewController.m
//  Fast news
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 ZDY. All rights reserved.
//

#import "LandingViewController.h"
#import "RegisterViewController.h"
#import "FMDBModel.h"
#import "ViewController.h"

@interface LandingViewController ()

@property (nonatomic, retain) UILabel *lable;
@property (nonatomic, retain) UITextField *tf;
@property (nonatomic, retain) UIButton *btn;
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

@property (nonatomic, retain) FMDatabaseQueue *queue;

@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除缓存" style:(UIBarButtonItemStylePlain) target:self action:@selector(clear)];
    
    self.title = @"登陆界面";
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    self.navigationItem.hidesBackButton = YES;

    // 设置背景图片
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 603)];
    _imageView.image = [UIImage imageNamed:@"background.png"];
    // 打开用户交互
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    
    [self customView];
    
    // 打开数据库
    self.queue = [FMDBModel shareDB];
    
}

- (void)customView {
    NSArray *accountArray = @[@"账号:", @"密码:"];
    NSArray *passwordArray = @[@"请输入账号:", @"请输入密码:"];
    NSArray *btnArray = @[@"登陆", @"注册"];
    
    for (int i = 0; i < 2; i++) {
        self.lable = [[UILabel alloc] initWithFrame:CGRectMake(30, 80 + 60 * i, 75, 40)];
        _lable.text = accountArray[i];
        _lable.backgroundColor = [UIColor cyanColor];
        _lable.textAlignment = NSTextAlignmentCenter;
        _lable.layer.masksToBounds = YES;
        _lable.layer.cornerRadius = 4;
        [_imageView addSubview:_lable];
        
        self.tf = [[UITextField alloc] initWithFrame:CGRectMake(130 , 80 + 60 * i, 215, 40)];
        _tf.placeholder = passwordArray[i];
        _tf.borderStyle = UITextBorderStyleRoundedRect;
        _tf.backgroundColor = [UIColor darkGrayColor];
        _tf.tag = 1000 + i;
        // 开始输入清除文本信息
        _tf.clearsOnBeginEditing = YES;
        [_imageView addSubview:_tf];
        
        self.btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _btn.frame = CGRectMake(50 + 165 * i, 230, 120, 40);
        [_btn setTitle:btnArray[i] forState:UIControlStateNormal];
        if (i == 0) {
            _btn.backgroundColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:75 / 255.0 alpha:1];
            [_btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 1) {
            _btn.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:130 / 255.0 blue:40 / 255.0 alpha:1];
            // 密文设置
            _tf.secureTextEntry = YES;
            [_btn addTarget:self action:@selector(registerPage) forControlEvents:UIControlEventTouchUpInside];
        }
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 4;
        [_imageView addSubview:_btn];
    }

}


#pragma mark - 跳转页面

- (void)back {
    UITextField *usernameTF = [self.view viewWithTag:1000];
    UITextField *passwordTF = [self.view viewWithTag:1001];
    
    if ([usernameTF.text isEqualToString:@""] || [passwordTF.text isEqualToString:@""]) {
        [self alter:@"账号或密码不能为空"];
    } else {
        [self.queue inDatabase:^(FMDatabase *db) {
            FMResultSet *rb = [db executeQuery:@"select * from userInfo"];
            while ([rb next]) {
                self.username = [rb stringForColumn:@"username"];
                self.password = [rb stringForColumn:@"password"];
                if ([_username isEqualToString:usernameTF.text] && [_password isEqualToString:passwordTF.text]) {
                    ViewController *viewVC = [[ViewController alloc] init];
                    [self.navigationController pushViewController:viewVC animated:YES];
                }
            }
            if (![_username isEqualToString:usernameTF.text] && ![_password isEqualToString:passwordTF.text]) {
                [self alter:@"账号或密码错误"];

            }
        }];
    }
    
}


- (void)alter:(NSString *)message {
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
    [alter addAction:action];
    [self presentViewController:alter animated:YES completion:nil];
}

- (void)registerPage {
    RegisterViewController *regist = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:regist animated:YES];
}


#pragma mark - 清除缓存

- (void)clear {
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"清除之后将无法恢复数据" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self.queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"delete from userInfo"];
        }];
        
        [self alter:@"清除完毕"];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alter addAction:action];
    [alter addAction:action1];
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
