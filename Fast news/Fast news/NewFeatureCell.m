//
//  NewFeatureCell.m
//  Fast news
//
//  Created by lanou3g on 15/11/20.
//  Copyright © 2015年 ZDY. All rights reserved.
//

#import "NewFeatureCell.h"

@interface NewFeatureCell ()

@property (nonatomic, retain) UIImageView *imageView;

@end

@implementation NewFeatureCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        // 注意：一定要加在contentView上面
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

// 调整子控件的位置
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;  // self.imageView.frame = [UIScreen mainScreen].bounds;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

@end
