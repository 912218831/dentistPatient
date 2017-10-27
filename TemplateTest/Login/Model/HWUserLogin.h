//
//  HWUserLogin.h
//  Template-OC
//
//  Created by niedi on 15/4/3.
//  Copyright (c) 2015年 caijingpeng.haowu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HWUserLogin : NSObject
@property(strong,nonatomic)NSString * userPhone;
@property(strong,nonatomic)NSString * username;
@property(strong,nonatomic)NSString * usertype;
@property(strong,nonatomic)NSString * userkey;
@property(strong,nonatomic)NSString * cityName;
@property(strong,nonatomic)NSString * cityId;
@property(strong,nonatomic)NSString * locationLat;
@property(strong,nonatomic)NSString * locationLong;
@property(strong,nonatomic)NSString * locationCityName;
+ (HWUserLogin *)currentUserLogin;

-(void)loadData;

// 注销
- (void)userLogout;



@end
