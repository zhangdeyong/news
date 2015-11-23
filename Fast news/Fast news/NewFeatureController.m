//
//  NewFeatureController.m
//  Fast news
//
//  Created by lanou3g on 15/11/20.
//  Copyright © 2015年 ZDY. All rights reserved.
//

#import "NewFeatureController.h"
#import "NewFeatureCell.h"
#import "ViewController.h"
#import "LandingViewController.h"

@interface NewFeatureController ()

@property (nonatomic, retain) UIPageControl *page;

// 传值
@property (nonatomic, assign) NSInteger number;

@end

@implementation NewFeatureController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // 设置cell的尺寸
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    // 清空行距
    layout.minimumLineSpacing = 0;
    // 设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewWillAppear:(BOOL)animated {
    // 创建PageControl
    _page = [[UIPageControl alloc] initWithFrame:CGRectMake(250, 600, 50, 25)];
    _page.currentPageIndicatorTintColor = [UIColor redColor];
    _page.numberOfPages = 4;
    _page.currentPage = 0;
    _page.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self.view addSubview:_page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.page.currentPage = _number;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置分页
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    // 注册
    [self.collectionView registerClass:[NewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.image = [UIImage imageNamed:[NSString stringWithFormat:@"pic%ld.png", indexPath.row + 1]];
    
    _number = indexPath.row;
    
    return cell;
}



#pragma mark <UICollectionViewDelegate>

// 点击跳转
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LandingViewController *landVC = [[LandingViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:landVC];
    nav.navigationBar.translucent = NO;
    [self showDetailViewController:nav sender:nil];
}


/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
