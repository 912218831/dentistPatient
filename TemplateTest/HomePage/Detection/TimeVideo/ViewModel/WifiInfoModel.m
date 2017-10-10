//
//  WifiInfoModel.m
//  HKSDKDemo
//
//  Created by 杨庆龙 on 2017/9/27.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "WifiInfoModel.h"

@implementation WifiInfoModel

- (instancetype)initWithInfo:(NSString *)info
{
    self = [super init];
    if (self) {
        
        NSArray * arr = [info componentsSeparatedByString:@";"];
        for (NSString * str in arr) {
            NSArray * tempArr = [str componentsSeparatedByString:@"="];
            if ([[tempArr objectAtIndex:0] isEqualToString:@"sid"]) {
                self.sid = [tempArr objectAtIndex:1];
            }
            if ([[tempArr objectAtIndex:0] isEqualToString:@"enc"]) {
                self.entype = [tempArr objectAtIndex:1];
            }
            if ([[tempArr objectAtIndex:0] isEqualToString:@"stype"]) {
                self.satype = [tempArr objectAtIndex:1];
            }

        }
    }
    return self;
}

@end
