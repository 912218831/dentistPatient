//
//  HWAppointListModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/21.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointListModel.h"

@implementation HWAppointListModel


+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *dic = (NSMutableDictionary*)[super JSONKeyPathsByPropertyKey];
    [dic setPObject:@"id" forKey:@"appointId"];
    return dic;
}
@end
