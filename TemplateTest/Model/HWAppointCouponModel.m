//
//  HWAppointCouponModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/22.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
// 优惠券

#import "HWAppointCouponModel.h"

@implementation HWAppointCouponModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        self.selected = NO;
    }
    return self;
}
@end
