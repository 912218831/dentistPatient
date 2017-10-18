//
//  AppShare.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/7/28.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "AppShare.h"
#import "HWCityModel_CD+CoreDataClass.h"
#import "HWLocationManager.h"
#import<SystemConfiguration/CaptiveNetwork.h>
#import<SystemConfiguration/SystemConfiguration.h>
#import<CoreFoundation/CoreFoundation.h>
#import "HWLoginViewModel.h"
#import "HWLoginViewController.h"
@implementation AppShare

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static AppShare * share = nil;
    dispatch_once(&onceToken, ^{
        share = [[AppShare alloc] init];
    });
    return share;
}

- (void)handelCurrentCoreDataLoginUser:(void (^)(HWLoginUser *))currentLoginUser
{
    HWLoginUser * loginUer;
    if ([HWLoginUser MR_findAll].count) {
         loginUer = [HWLoginUser MR_findFirst];
    }
    else
    {
         loginUer = [HWLoginUser MR_createEntity];
    }
    if (currentLoginUser) {
        dispatch_async(dispatch_get_main_queue(), ^{
            currentLoginUser(loginUer);
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            [[HWUserLogin currentUserLogin] loadData];
        });
    }
}

- (void)startLocation:(void (^)())locationSuccess locactionFail:(void (^)())locationFail
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    //定位
    HWLocationManager * locationManger = [HWLocationManager shareManager];
    [locationManger startLocating];
    if (![locationManger startLocating]) {
        [Utility showToastWithMessage:@"请检查定位权限"];
        return;
    }
    @weakify(locationManger);
    [locationManger setLocationSuccess:^(CLLocation * loc , NSString * cityName,NSString *streetName) {
        /**
         *  后台数据库没有城市没有"市"
         */
        [userDefault setObject:@"0" forKey:@"kLocationTime"];
        
        NSRange range = [cityName rangeOfString:@"市"];
        if (range.location != NSNotFound)
        {
            cityName = [cityName substringToIndex:range.location];
        }
        
        if (cityName.length > 4)
        {
            cityName = [cityName substringToIndex:4];
        }
        
        if (cityName.length > 0) {
            
            [HWUserLogin currentUserLogin].locationCityName = cityName;
            [HWUserLogin currentUserLogin].locationLat = [NSString stringWithFormat:@"%f",loc.coordinate.latitude];
            [HWUserLogin currentUserLogin].locationLong = [NSString stringWithFormat:@"%f",loc.coordinate.longitude];
        }
        
        if (locationSuccess) {
            locationSuccess();
        }
    }];
    [locationManger setLocationFailed:^(BOOL isOpenLocator){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationFailNotification object:nil];
        
        NSString *lTime = [userDefault objectForKey:@"kLocationTime"];
        if (lTime.intValue < 5)
        {
            // 失败 3次以上 停止定位
            @strongify(locationManger);
            [locationManger startLocating];
            [userDefault setObject:[NSString stringWithFormat:@"%d", lTime.intValue + 1] forKey:@"kLocationTime"];
            [userDefault synchronize];
        }
        else
        {
            [HWUserLogin currentUserLogin].locationCityName = @"";
            [HWUserLogin currentUserLogin].locationLat = @"";
            [HWUserLogin currentUserLogin].locationLong = @"";
            if (locationFail) {
                locationFail();
            }
        }
        
    }];

}

- (UIViewController *)checkUserType
{
    
    HWTabBarViewController * ctrl = [[HWTabBarViewController alloc] init];
    //        SHARED_APP_DELEGATE.viewController = ctrl;
    return (RDVTabBarController*)ctrl;

}

- (void)getCityList
{
    HWHTTPSessionManger * manager = [HWHTTPSessionManger manager];
    [manager POST:kCityList parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        NSArray * dataArr = [responseObject objectForKey:@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [HWCityModel_CD MR_truncateAll];
            for (NSDictionary * dic in dataArr) {
                HWCityModel_CD * cityModel = [HWCityModel_CD MR_createEntity];
                cityModel.cityId = [dic objectForKey:@"cityCode"];
                cityModel.name = [dic objectForKey:@"cityName"];
                cityModel.pinyin = [dic objectForKey:@"pinyin"];
                NSString * tempStr = [NSString stringWithFormat:@"%c",[cityModel.pinyin characterAtIndex:0]];
                cityModel.cityFirstChar = tempStr.uppercaseString;
                NSString * transformPinYin = [Utility transform:cityModel.name];
                NSArray * tempArr = [transformPinYin componentsSeparatedByString:@" "];
                NSMutableArray * tempMutableArr = [NSMutableArray arrayWithCapacity:tempArr.count];
                for (NSString * str in tempArr) {
                    [tempMutableArr addObject:[NSString stringWithFormat:@"%c",[str characterAtIndex:0]]];
                }
                cityModel.pinyinHeader = [tempMutableArr componentsJoinedByString:@""];
            }
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        });

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSString *)getCurrentWifiName
{
    NSString *wifiName = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    
    if (myArray != nil) {
        
        CFDictionaryRef myDict =CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        
        if (myDict != nil) {
            
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            wifiName = [dict valueForKey:@"SSID"];
            
        }
        
        NSLog(@"wifiName:%@", wifiName);
    }
    return wifiName;
}

- (void)logout
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[HWUserLogin currentUserLogin] userLogout];
        HWLoginViewModel * viewModel = [HWLoginViewModel new];
        HWLoginViewController * loginCtrl = [[HWLoginViewController alloc] initWithViewModel:viewModel];
        HWBaseNavigationController * nav = [[HWBaseNavigationController alloc] initWithRootViewController:loginCtrl];
        nav.view.backgroundColor = [UIColor whiteColor];
        [(SHARED_APP_DELEGATE).window.rootViewController presentViewController:nav animated:YES completion:^{
            [SHARED_APP_DELEGATE.window setRootViewController:nav];
        }];
        
    });

}

@end
