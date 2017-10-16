//
//  HWAppointListModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/21.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointListModel.h"

@implementation HWAppointListModel


+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *dic = (NSMutableDictionary*)[super JSONKeyPathsByPropertyKey];
    [dic setPObject:@"id" forKey:@"appointId"];
    return dic;
}
- (id)copyWithZone:(NSZone *)zone
{
    HWAppointListModel * model = [[HWAppointListModel alloc] init];
    model.appointId = self.appointId;
    model.checkId = self.checkId;
    model.familyId = self.familyId;
    model.patintId = self.patintId;
    model.dentistId = self.dentistId;
    model.expectedTime = self.expectedTime;
    model.amPm = self.amPm;
    model.dentistAgreedFlag = self.dentistAgreedFlag;
    model.patintAgreedFlag = self.patintAgreedFlag;
    model.createTime = self.createTime;
    model.state = self.state;
    model.dentistName = self.dentistName;
    model.patintName = self.patintName;
    model.stateDes = self.stateDes;
    model.clinicName = self.clinicName;
    model.headImgUrl = self.headImgUrl;
    return model;
}
- (id)mutableCopyWithZone:(NSZone *)zone
{
    HWAppointListModel * model = [[HWAppointListModel alloc] init];
    model.appointId = self.appointId;
    model.checkId = self.checkId;
    model.familyId = self.familyId;
    model.patintId = self.patintId;
    model.dentistId = self.dentistId;
    model.expectedTime = self.expectedTime;
    model.amPm = self.amPm;
    model.dentistAgreedFlag = self.dentistAgreedFlag;
    model.patintAgreedFlag = self.patintAgreedFlag;
    model.createTime = self.createTime;
    model.state = self.state;
    model.dentistName = self.dentistName;
    model.patintName = self.patintName;
    model.stateDes = self.stateDes;
    model.clinicName = self.clinicName;
    model.headImgUrl = self.headImgUrl;
    return model;

}
@end
