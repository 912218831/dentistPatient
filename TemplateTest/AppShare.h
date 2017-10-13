//
//  AppShare.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/7/28.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWLoginUser+CoreDataProperties.h"
#import "HWTabBarViewController.h"

@interface AppShare : NSObject

+ (instancetype)shareInstance;
- (void)getCityList;

- (void)handelCurrentCoreDataLoginUser:(void(^)(HWLoginUser * loginUser))currentLoginUser;

- (void)startLocation:(void(^)())locationSuccess locactionFail:(void(^)())locationFail;

- (UIViewController *)checkUserType;
- (NSString *)getCurrentWifiName;
- (NSString *)getIPAddress;
@end
