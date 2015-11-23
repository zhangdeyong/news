//
//  QrCodeController.m
//  Fast news
//
//  Created by lanou3g on 15/11/20.
//  Copyright © 2015年 ZDY. All rights reserved.
//

#import "QrCodeController.h"
#import "SHBQRView.h"

@interface QrCodeController ()<SHBQRViewDelegate>

@end

@implementation QrCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫扫更健康";
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    SHBQRView *qr = [[SHBQRView alloc] initWithFrame:self.view.bounds];
    qr.delegate = self;
    [self.view addSubview:qr];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)qrView:(SHBQRView *)view ScanResult:(NSString *)result {
    [view stopScan];
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"扫描结果：%@", result] preferredStyle:(UIAlertControllerStyleAlert)];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [view startScan];
    }]];
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
