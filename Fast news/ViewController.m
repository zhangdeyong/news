//
//  ViewController.m
//  Fast news
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 ZDY. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "Headlines.h"
#import "DetailViewController.h"
#import "QrCodeController.h"
#import "LandingViewController.h"
#import "SetController.h"

@interface ViewController ()<UITableViewDataSource, UIScrollViewDelegate, UITableViewDelegate>

// 控件
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIScrollView *scroll;
@property (nonatomic, retain) UIPageControl *page;
@property (nonatomic, retain) UIImageView *img1;
@property (nonatomic, retain) UIImageView *img2;
@property (nonatomic, retain) UILabel *lable1;
@property (nonatomic, retain) UILabel *lable2;
@property (nonatomic, retain) UIButton *btn1;
@property (nonatomic, retain) UIButton *btn2;


// 保存数据
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *dataArray1;

// 传值
@property (nonatomic, assign) NSIndexPath *path;
@property (nonatomic, assign) NSInteger number;

@end

static NSString *identifer = @"newscell";

@implementation ViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"网易新闻";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"扫一扫" style:(UIBarButtonItemStylePlain) target:self action:@selector(GoToQrCode)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:(UIBarButtonItemStylePlain) target:self action:@selector(set)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 保存标题
    NSArray *array = [NSArray arrayWithObjects:@"头条", @"娱乐", @"体育", @"科技", @"财经", @"社会", @"视频", @"图片", nil];
    
    // 创建SegmentedControl
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:array];
    segmentControl.frame = CGRectMake(0, 0, 375, 40);
    [segmentControl setBackgroundColor:[UIColor whiteColor]];
    segmentControl.apportionsSegmentWidthsByContent = YES;
    segmentControl.selectedSegmentIndex = 0;
    [segmentControl addTarget:self action:@selector(segmenteClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
    
    // 创建表示图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 375, 560) style:(UITableViewStylePlain)];
    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identifer];
    _tableView.separatorColor = [UIColor grayColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 100;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];

    // 设置头视图并添加相关控件
    UIView *blue = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 200)];
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, 200)];
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.delegate = self;
    _scroll.contentSize = CGSizeMake(375 * 2, 175);
    _scroll.pagingEnabled = YES;
    self.btn1 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _btn1.frame = CGRectMake(0, 0, 375, 175);
    [_btn1 addTarget:self action:@selector(GoDetail:) forControlEvents:(UIControlEventTouchUpInside)];
    [_scroll addSubview:_btn1];
    self.btn2 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _btn2.frame = CGRectMake(375, 0, 375, 175);
    [_btn1 addTarget:self action:@selector(GoDetail:) forControlEvents:(UIControlEventTouchUpInside)];
    [_scroll addSubview:_btn2];
    self.img1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 175)];
    self.img2 = [[UIImageView alloc] initWithFrame:CGRectMake(375, 0, 375, 175)];
    [_btn1 addSubview:_img1];
    [_btn1 addSubview:_img2];
    [blue addSubview:_scroll];
    self.lable1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 175, 280, 25)];
    _lable1.font = [UIFont systemFontOfSize:14];
    [_scroll addSubview:_lable1];
    self.lable2 = [[UILabel alloc] initWithFrame:CGRectMake(395, 175, 280, 25)];
    _lable2.font = [UIFont systemFontOfSize:14];
    [_scroll addSubview:_lable2];
    self.tableView.tableHeaderView = blue;
    
    // 创建PageControl
    _page = [[UIPageControl alloc] initWithFrame:CGRectMake(325, 175, 25, 25)];
    _page.currentPageIndicatorTintColor = [UIColor cyanColor];
    _page.numberOfPages = 2;
    _page.currentPage = 0;
    _page.pageIndicatorTintColor = [UIColor lightGrayColor];
    [_page addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    [blue addSubview:_page];
    
    // 显示主界面
    [self datapars:[NSURL URLWithString:kheadlinesURL] number:@"T1348647853363"];

    // 下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(test)];
 
    // 自动下拉刷新
    [self.tableView headerBeginRefreshing];
    
    // 上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(test1)];
}

#pragma mark - 跳转页面
- (void)GoToQrCode {
    QrCodeController *qrVC = [[QrCodeController alloc] init];
    [self.navigationController pushViewController:qrVC animated:YES];
}

- (void)GoDetail:(UIButton *)sender {
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    NSDictionary *dic = self.dataArray1[0];
    detailVC.url = dic[@"url_3w"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)set {
    SetController *set = [[SetController alloc] init];
    [self.navigationController pushViewController:set animated:YES];
}

#pragma mark - 下拉刷新
- (void)test{
    if (self.number == 1) {
        [self datapars:[NSURL URLWithString:kentertainmentURL] number:@"T1348648517839"];
    } else if (self.number == 2) {
        [self datapars:[NSURL URLWithString:ksportURL] number:@"T1348649079062"];
    } else if (self.number == 3) {
        [self datapars:[NSURL URLWithString:ktechnologyURL] number:@"T1348649580692"];
    } else if (self.number == 4) {
        [self datapars:[NSURL URLWithString:keconomicsURL] number:@"T1348648756099"];
    } else if (self.number == 5) {
        [self datapars:[NSURL URLWithString:ksocialURL] number:@"T1348648037603"];
    } else if (self.number == 0) {
        [self datapars:[NSURL URLWithString:kheadlinesURL] number:@"T1348647853363"];
    }
}

#pragma mark - 上拉加载
- (void)test1{
    if (self.number == 1) {
        [self datapars2:[NSURL URLWithString:kentertainmentURL] number:@"T1348648517839"];
    } else if (self.number == 2) {
        [self datapars2:[NSURL URLWithString:ksportURL] number:@"T1348649079062"];
    } else if (self.number == 3) {
        [self datapars2:[NSURL URLWithString:ktechnologyURL] number:@"T1348649580692"];
    } else if (self.number == 4) {
        [self datapars2:[NSURL URLWithString:keconomicsURL] number:@"T1348648756099"];
    } else if (self.number == 5) {
        [self datapars2:[NSURL URLWithString:ksocialURL] number:@"T1348648037603"];
    } else if (self.number == 0) {
        [self datapars2:[NSURL URLWithString:kheadlinesURL] number:@"T1348647853363"];
    }
}


#pragma mark - 轮播图

- (void)pageAction:(UIPageControl *)sender {
    NSInteger index = sender.currentPage;
    _scroll.contentOffset = CGPointMake(375 * index, 0);
    _page.currentPage = _scroll.contentOffset.x / 375;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = self.scroll.contentOffset.x / 375;
    self.page.currentPage = index;
}


#pragma mark - 解析数据

- (void)datapars:(NSURL *)urlStr number:(NSString *)numberStr {
    // 清空数组元素
    if (self.dataArray.count && self.dataArray1.count) {
        [self.dataArray removeAllObjects];
        [self.dataArray1 removeAllObjects];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof (self)temp = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // 结束下拉刷新
        [self.tableView headerEndRefreshing];
        
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSArray *array = dic[numberStr];
            NSMutableArray *addArray = [NSMutableArray array];
            NSMutableArray *addArray1 = [NSMutableArray array];
            for (NSDictionary *dict in array) {
                Headlines *head = [Headlines new];
                [head setValuesForKeysWithDictionary:dict];
                [addArray addObject:head];
                [addArray1 addObject:dict];
            }
            
            // 将刷新的数据插入到数组中
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, addArray.count)];
            [temp.dataArray insertObjects:addArray atIndexes:indexSet];
            NSIndexSet *indexSet1 = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, addArray1.count)];
            [temp.dataArray1 insertObjects:addArray1 atIndexes:indexSet1];
            
        }
        // GCD返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            // 解析轮播图
            NSDictionary *imgDic = temp.dataArray1[0];
            NSArray *imgArray = imgDic[@"ads"];
            NSMutableArray *array = [NSMutableArray array];
            if (imgArray.count >= 2) {
                for (int i = 0; i < 2; i++) {
                    [array addObject:imgArray[i]];
                }
                // 加载图片
                [temp.img1 sd_setImageWithURL:[NSURL URLWithString:array[0][@"imgsrc"]]];
                [temp.img2 sd_setImageWithURL:[NSURL URLWithString:array[1][@"imgsrc"]]];
                // 加载图片标题
                self.lable1.text = array[0][@"title"];
                self.lable2.text = array[1][@"title"];
            } else if (imgArray.count == 1) {
                for (int i = 0; i < 1; i++) {
                    [array addObject:imgArray[i]];
                }
                [temp.img1 sd_setImageWithURL:[NSURL URLWithString:array[0][@"imgsrc"]]];
                self.lable1.text = array[0][@"title"];
            }
            [temp.tableView reloadData];
            
            // 切换到顶部
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
        });
    }];
    
    [task resume];

}

// ToDo : 上拉加载没实现
- (void)datapars2:(NSURL *)urlStr number:(NSString *)numberStr {
    
    //    NSLog(@"%ld", self.dataArray.count);
    
    //    static int value = 0;
    
    
    //    if (<#condition#>) {
    //        <#statements#>
    //    }
    
    
    NSString *str = [NSString stringWithFormat:@"%@", urlStr];
    NSRange range = {56, 2};
    int number = [[str substringWithRange:range] intValue] + 20;
    NSString *str2 = [NSString stringWithFormat:@"%d", number];
    NSString *str3 = [str stringByReplacingCharactersInRange:range withString:str2];
    NSLog(@"%@", str3);
    NSURL *url = [NSURL URLWithString:str3];
    //    value = number;
    
    // 获取之前数组最后一个元素的priority
    Headlines *head = [self.dataArray lastObject];
    NSInteger maxPri = head.priority;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof (self)temp = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // 结束上拉加载
        [self.tableView footerEndRefreshing];
        
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSArray *array = dic[numberStr];
            NSMutableArray *addArray = [NSMutableArray array];
            for (NSDictionary *dict in array) {
                Headlines *head = [Headlines new];
                [head setValuesForKeysWithDictionary:dict];
                if (head.priority < maxPri) {
                    //                    http://c.m.163.com/nc/article/headline/T1348647853363/0-20.html
                    // 清空数组元素
                    if (self.dataArray.count && self.dataArray1.count) {
                        [self.dataArray removeAllObjects];
                    }
                    
                    [addArray addObject:head];
                }
            }
            
            [temp.dataArray addObjectsFromArray:addArray];
        }
        // GCD返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [temp.tableView reloadData];
        });
    }];
    
    [task resume];
}


#pragma mark - Segmente触发事件

- (void)segmenteClick:(UISegmentedControl *)sender {
    self.number = sender.selectedSegmentIndex;
    
    if (sender.selectedSegmentIndex == 1) {
        [self datapars:[NSURL URLWithString:kentertainmentURL] number:@"T1348648517839"];
    } else if (sender.selectedSegmentIndex == 2) {
        [self datapars:[NSURL URLWithString:ksportURL] number:@"T1348649079062"];
    } else if (sender.selectedSegmentIndex == 3) {
        [self datapars:[NSURL URLWithString:ktechnologyURL] number:@"T1348649580692"];
    } else if (sender.selectedSegmentIndex == 4) {
        [self datapars:[NSURL URLWithString:keconomicsURL] number:@"T1348648756099"];
    } else if (sender.selectedSegmentIndex == 5) {
        [self datapars:[NSURL URLWithString:ksocialURL] number:@"T1348648037603"];
    } else if (sender.selectedSegmentIndex == 0) {
        [self datapars:[NSURL URLWithString:kheadlinesURL] number:@"T1348647853363"];
    }
//    else if (sender.selectedSegmentIndex == 6) {
//        [self datapars:[NSURL URLWithString:ksportURL] number:@"T1348649079062"];
//    } else if (sender.selectedSegmentIndex == 7) {
//        [self datapars:[NSURL URLWithString:ksportURL] number:@"T1348649079062"];
//    }

}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    
    if (indexPath.row < self.dataArray.count - 1) {
        Headlines *head = self.dataArray[indexPath.row + 1];
        cell.head = head;
    }
   
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    if (indexPath.row < self.dataArray.count - 1) {
        Headlines *head = self.dataArray[indexPath.row + 1];
        detailVC.url = head.url_3w;
    }

    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - 懒加载

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)dataArray1 {
    if (!_dataArray1) {
        _dataArray1 = [NSMutableArray array];
    }
    return _dataArray1;
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
