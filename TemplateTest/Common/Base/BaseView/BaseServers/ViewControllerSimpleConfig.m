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
             kDetectionCaptureVM:self.detectionCapture,
             kTimeVideoVM:self.timeVideo,
             kDetectionResultVM:self.detectionResult,
             kRDoctorVM:self.recommandDoctor,
             kRDoctorDetailVM:self.doctorDetail,
             kAppointmentVM:self.appointment,
             kAppointFailVM:self.appointFail,
             kAppointWaitingVM:self.appointWaiting,
             kAppointSuccessVM:self.appointSuccess,
             kAppointFinishVM:self.appointFinish,
             kSelectCityVM:self.selectCity,
             kBaseWebViewModel:self.webView,
             kSetPasswordViewModel:self.setPassword,
             kSettingDeviceVM:self.settingAutoDevice
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

+ (NSDictionary *)timeVideo {
    return @{
             @"title":@"请按快门",
             @"leftImageName":@"TOP_ARROW",
             @"rightImageName":@"right"
             };
}

+ (NSDictionary *)detectionResult {
    return @{
             @"title":@"检测结果",
             @"leftImageName":@"TOP_ARROW",
             @"rightImageName":@"right"
             };
}

+ (NSDictionary *)recommandDoctor {
    return @{
             @"title":@"选择医生",
             @"leftImageName":@"TOP_ARROW",
             @"rightImageName":@"right"
             };
}

+ (NSDictionary *)doctorDetail {
    return @{
             @"title":@"医生详情",
             @"leftImageName":@"TOP_ARROW",
             @"rightImageName":@"right"
             };
}
+(NSDictionary*)appointment{
    return @{
             @"title":@"我的预约"
             };
}

+ (NSDictionary*)appointFail{
    return @{
             @"title":@"预约详情",
             @"leftImageName":@"TOP_ARROW",
             @"rightImageName":@"right"
             };
}
+ (NSDictionary*)appointWaiting{
    return @{
             @"title":@"预约详情",
             @"leftImageName":@"TOP_ARROW",
             @"rightImageName":@"right"
             };
}
+ (NSDictionary*)appointSuccess{
    return @{
             @"title":@"预约详情",
             @"leftImageName":@"TOP_ARROW",
             @"rightImageName":@"right"
             };
}
+ (NSDictionary *)appointFinish{
    return @{
             @"title":@"预约详情",
             @"leftImageName":@"TOP_ARROW",
             @"rightImageName":@"right"
             };
}
+ (NSDictionary*)selectCity{
    return @{
             @"title":@"城市选择",
             @"leftImageName":@"TOP_ARROW",
             @"rightImageName":@"right"
             };
}
+ (NSDictionary *)webView{
    
    return @{
             @"title":@"webView",
             @"leftImageName":@"TOP_ARROW",
             @"rightImageName":@"right"
             };
}
+ (NSDictionary *)setPassword {
    
    return @{
             @"title":@"设置密码",
             @"leftImageName":@"TOP_ARROW",
             };
}
+ (NSDictionary *)settingAutoDevice {
    return @{
             @"title":@"设置智能设备",
             @"leftImageName":@"TOP_ARROW",
             };
}
@end
