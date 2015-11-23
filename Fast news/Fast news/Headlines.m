//
//  Headlines.m
//  Fast news
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 ZDY. All rights reserved.
//

#import "Headlines.h"

@implementation Headlines

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ -- %@", _title, _digest];
}

@end
