//
//  TableViewCell.m
//  Fast news
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 ZDY. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHead:(Headlines *)head {
    _title.text = head.title;
    _digest.text = head.digest;
    _replyCount.text = [NSString stringWithFormat:@"跟帖数：%ld", head.replyCount];
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:head.imgsrc]];
}

@end
