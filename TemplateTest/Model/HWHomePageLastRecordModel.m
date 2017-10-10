//
//  HWHomePageLastRecordModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/20.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWHomePageLastRecordModel.h"

@implementation HWHomePageLastRecordModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *mutableKeys = [[NSDictionary mtl_identityPropertyMapWithModel:self]mutableCopy];;
    if([mutableKeys objectForKey:@"recodeId"]){
        [mutableKeys setObject:@"id" forKey:@"recodeId"];
    }
    return mutableKeys;

}

@end
