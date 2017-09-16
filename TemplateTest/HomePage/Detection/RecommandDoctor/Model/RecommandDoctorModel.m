//
//  RecommandDoctorModel.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "RecommandDoctorModel.h"

@implementation RecommandDoctorModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *dic = (NSMutableDictionary*)[super JSONKeyPathsByPropertyKey];
    [dic setObject:@"description" forKey:@"descrip"];
    return dic;
}

@end
