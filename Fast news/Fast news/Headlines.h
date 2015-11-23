//
//  Headlines.h
//  Fast news
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 ZDY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Headlines : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *digest;
@property (nonatomic, assign) NSInteger replyCount;
@property (nonatomic, retain) NSString *url_3w;
@property (nonatomic, retain) NSString *imgsrc;
@property (nonatomic, assign) NSInteger priority;

@end
