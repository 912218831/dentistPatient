//
//  DoctorDetailModel.m
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DoctorDetailModel.h"

@implementation DoctorDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *dic = (NSMutableDictionary *)[super JSONKeyPathsByPropertyKey];
    dic[@"descrip"] = @"description";
    dic[@"lon"] = @"long";
    return dic;
}

@end
