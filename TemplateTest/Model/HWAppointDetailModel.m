//
//  HWAppointDetailModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/21.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointDetailModel.h"

@implementation HWAppointDetailModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *dic = (NSMutableDictionary*)[super JSONKeyPathsByPropertyKey];
    [dic setPObject:@"id" forKey:@"appointId"];
    [dic setPObject:@"long" forKey:@"longitude"];
    [dic setPObject:@"lat" forKey:@"latitude"];
    return dic;
}
@end
