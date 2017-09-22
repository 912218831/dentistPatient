//
//  HWAppointCouponModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/22.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseModel.h"
/*
 "couponIndexId": "1",
 "couponTitle": "\u6ee1500\u51cf30",
 "couponDescription": "\u6d88\u8d39\u6ee1500\u51cf30\u5143,\u73b0\u91d1\u8fd4\u8fd8. \u6293\u7d27\u65f6\u95f4.",
 "minConsumptionPrice": "500",
 "deductiblePrice": "30",
 "validityDate": "2017-09-28 14:23:51",
 "couponId": "1",
 "couponCode": "XJ0012"
 */
@interface HWAppointCouponModel : BaseModel
@property(copy,nonatomic)NSString * couponIndexId;
@property(copy,nonatomic)NSString * couponTitle;
@property(copy,nonatomic)NSString * couponDescription;
@property(copy,nonatomic)NSString * minConsumptionPrice;
@property(copy,nonatomic)NSString * deductiblePrice;
@property(copy,nonatomic)NSString * validityDate;
@property(copy,nonatomic)NSString * couponId;
@property(copy,nonatomic)NSString * XJ0012;
@property(assign,nonatomic)BOOL selected;
@end
