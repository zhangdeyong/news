//
//  TableViewCell.h
//  Fast news
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 ZDY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headlines.h"

@interface TableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *digest;
@property (strong, nonatomic) IBOutlet UILabel *replyCount;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;


@property (nonatomic, retain) Headlines *head;

@end
