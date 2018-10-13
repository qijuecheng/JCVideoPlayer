//
//  NSString+QJCTime.m
//  播放器Demo
//
//  Created by 漆珏成 on 2018/8/16.
//  Copyright © 2018年 漆珏成. All rights reserved.
//

#import "NSString+JCTime.h"

@implementation NSString (JCTime)
+ (NSString *)convertTime:(float)second {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second / 3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *newTime = [formatter stringFromDate:date];
    return newTime;
}
@end
