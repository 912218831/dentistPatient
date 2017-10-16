//
//  HWAppointListModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/21.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseModel.h"
/*
 "id": "3",
 "checkId": null,
 "familyId": "1",
 "patintId": "1",
 "dentistId": "1",
 "expectedTime": "2017-09-08 00:00:00",
 "amPm": "1",
 "dentistAgreedFlag": "0",
 "patintAgreedFlag": "1",
 "createTime": "2017-09-10 23:29:16",
 "state": "2",
 "patintName": "家庭成员01",
 "dentistName": "张医生",
 "headImgUrl": "http://test.jpg",
 "stateDes": "放弃/过期",
 "clinicName":"上海九院"
 */
@interface HWAppointListModel : BaseModel<MTLJSONSerializing,NSCopying,NSMutableCopying>
@property(copy,nonatomic)NSString * appointId;
@property(copy,nonatomic)NSString * checkId;
@property(copy,nonatomic)NSString * familyId;
@property(copy,nonatomic)NSString * patintId;
@property(copy,nonatomic)NSString * dentistId;
@property(copy,nonatomic)NSString * expectedTime;
@property(copy,nonatomic)NSString * amPm;
@property(copy,nonatomic)NSString * dentistAgreedFlag;
@property(copy,nonatomic)NSString * patintAgreedFlag;
@property(copy,nonatomic)NSString * createTime;
@property(copy,nonatomic)NSString * state;
@property(copy,nonatomic)NSString * patintName;
@property(copy,nonatomic)NSString * dentistName;
@property(copy,nonatomic)NSString * headImgUrl;
@property(copy,nonatomic)NSString * stateDes;
@property(copy,nonatomic)NSString * clinicName;

@end
