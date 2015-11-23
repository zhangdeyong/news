//
//  FMDBModel.m
//  Fast news
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 ZDY. All rights reserved.
//

#import "FMDBModel.h"

static FMDatabaseQueue *queue;

@implementation FMDBModel

+ (FMDatabaseQueue *)shareDB {
    if (!queue) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [documentPath stringByAppendingString:@"/data.sqlite"];
        NSLog(@"%@", path);
        
        // 1、根据路径创建数据库
        queue = [FMDatabaseQueue databaseQueueWithPath:path];
        // 2、打开数据库
        [queue inDatabase:^(FMDatabase *db) {
           // 3、创建表
            [db executeUpdate:@"create table if not exists userInfo (username text, password text, email text, telephone text);"];
        }];
    }
    return queue;
}

@end
