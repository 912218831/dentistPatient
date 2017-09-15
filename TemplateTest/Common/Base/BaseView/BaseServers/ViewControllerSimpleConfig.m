//
//  ViewControllerSimpleConfig.m
//  MVVMFrame
//
//  Created by lizhongqiang on 16/7/28.
//  Copyright © 2016年 lizhongqiang. All rights reserved.
//

#import "ViewControllerSimpleConfig.h"

@implementation ViewControllerSimpleConfig

+ (NSDictionary *)viewModelSimpleConfigMappings:(id)viewModel {
    BOOL result = isKindClass(viewModel, "BaseViewModel")
    if (result == NO) {
        result = isSubClass(viewModel, "BaseViewModel");
    }
    if (result == NO) {
        return @{};
    }
    const char *name = class_getName([viewModel class]);
    NSString *nameStr = [NSString stringWithUTF8String:name];
    return [self.map dictionaryObjectForKey:nameStr];
}

+ (NSDictionary *)map {
    return @{
             kCasesVM:self.caseVC,
             kCaseDetailVM:self.caseDetail
             };
}

+ (NSDictionary *)caseVC {
    return @{
             @"title":@"病历",
             };
}

+ (NSDictionary *)caseDetail {
    return @{
             @"title":@"病例详情",
             @"leftImageName":@"TOP_ARROW",
             @"rightImageName":@"right"
             };
}

+ (NSDictionary *)recoverPassword {
    return @{
             @"title":@"找回密码",
             @"leftImageName":@"TOP_ARROW",
             @"rightImageName":@"right"
             };
}

+ (NSDictionary *)reserverRecord {
    return @{
             @"title":@"我的病人",
             };
}

+ (NSDictionary *)reserverDetail {
    return @{
             @"leftImageName":@"TOP_ARROW",
             };
}

+ (NSDictionary *)peopleCenter {
    return @{
             @"title":@"设置",
             };
}

+ (NSDictionary *)setPassword {
    return @{
             @"title":@"设置密码",
             @"leftImageName":@"TOP_ARROW",
             };
}
@end
