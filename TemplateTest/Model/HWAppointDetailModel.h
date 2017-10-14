//
//  HWAppointDetailModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/21.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

/*
 "id": "2",
 "checkId": "1",
 "familyId": "1",
 "patintId": "1",
 "dentistId": "1",
 "expectedTime": "2017-09-15 00:00:00",
 "docExpectedTime": "2017-10-01 00:00:00",
 "amPm": "1",
 "docAmPm": "1",
 "dentistAgreedFlag": "0",
 "patintAgreedFlag": "1",
 "createTime": "2017-09-10 23:28:50",
 "state": "4",
 payInfo = "";
 state = 1;
 stateDes = "\U7b49\U5f85\U533b\U751f\U786e\U8ba4";
 "patintName": "\u5bb6\u5ead\u6210\u545801",
 "dentistName": "\u5f20\u533b\u751f",
 "patientCount": "0",
 "docLevel": "3",
 "headImgUrl": "http:\/\/test.jpg",
 "stateDes": "\u533b\u751f\u5efa\u8bae\u4e86\u5176\u4ed6\u65f6\u95f4,\u8bf7\u786e\u8ba4.",
 "address": "\u4e0a\u6d77\u5e02\u5236\u9020\u5c40\u8def899\u5f04",
 "long": null,
 "lat": null,
 "clinicName": "\u4e0a\u6d77\u7b2c\u4e5d\u4eba\u6c11\u533b\u9662"
  */
#import "BaseModel.h"

@interface HWAppointDetailModel : BaseModel<MTLJSONSerializing>
@property(copy,nonatomic)NSString * appointId;
@property(copy,nonatomic)NSString * checkId;
@property(copy,nonatomic)NSString * familyId;
@property(copy,nonatomic)NSString * patintId;
@property(copy,nonatomic)NSString * dentistId;
@property(copy,nonatomic)NSString * expectedTime;
@property(copy,nonatomic)NSString * docExpectedTime;
@property(copy,nonatomic)NSString * amPm;
@property(copy,nonatomic)NSString * docAmPm;
@property(copy,nonatomic)NSString * dentistAgreedFlag;
@property(copy,nonatomic)NSString * patintAgreedFlag;
@property(copy,nonatomic)NSString * createTime;
@property(copy,nonatomic)NSString * state;
@property(copy,nonatomic)NSString * patintName;
@property(copy,nonatomic)NSString * dentistName;
@property(copy,nonatomic)NSString * patientCount;
@property(copy,nonatomic)NSString * docLevel;

@property(copy,nonatomic)NSString * headImgUrl;
@property(copy,nonatomic)NSString * stateDes;
@property(copy,nonatomic)NSString * payInfo;

@property(copy,nonatomic)NSString * address;
@property(copy,nonatomic)NSString * longitude ;
@property(copy,nonatomic)NSString * latitude ;
@property(copy,nonatomic)NSString * clinicName;

@end
