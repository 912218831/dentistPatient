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
             kCaseDetailVM:self.caseDetail,
             kDetectionVM:self.detectionSelect,
             kDetectionCaptureVM:self.detectionCapture
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

+ (NSDictionary *)detectionSelect {
    return @{
             @"title":@"牙菌斑检测 - 选择",
             @"leftImageName":@"TOP_ARROW",
             @"rightImageName":@"right"
             };
}

+ (NSDictionary *)detectionCapture {
    return @{
             @"title":@"牙菌斑检测",
             @"leftImageName":@"TOP_ARROW",
             @"rightImageName":@"right"
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
