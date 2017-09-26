//
//  AppShare.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/7/28.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "AppShare.h"
#import "HWCityModel_CD+CoreDataClass.h"
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
        currentLoginUser(loginUer);
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [[HWUserLogin currentUserLogin] loadData];
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
                cityModel.pinyin = [Utility transform:cityModel.name];
                NSString * tempStr = [NSString stringWithFormat:@"%c",[cityModel.pinyin characterAtIndex:0]];
                cityModel.cityFirstChar = tempStr.uppercaseString;
            }
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        });

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
