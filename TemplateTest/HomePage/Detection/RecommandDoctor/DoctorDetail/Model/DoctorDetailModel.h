//
//  DoctorDetailModel.h
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseModel.h"
#import "DoctorDetailTimeListModel.h"

@interface DoctorDetailModel : BaseModel
@property (nonatomic, copy) NSString* address;
@property (nonatomic, copy) NSString* averagePaice;
@property (nonatomic, copy) NSString* baseinfoid;
@property (nonatomic, copy) NSString* clinicName;
@property (nonatomic, copy) NSString* clinicid;
@property (nonatomic, copy) NSString* descrip;
@property (nonatomic, copy) NSString* headImgUrl;
@property (nonatomic, copy) NSString* Id;
@property (nonatomic, copy) NSString* lat;
@property (nonatomic, copy) NSString* level;
@property (nonatomic, copy) NSString* lon;
@property (nonatomic, copy) NSString* mobile;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* patientCount;
@end
