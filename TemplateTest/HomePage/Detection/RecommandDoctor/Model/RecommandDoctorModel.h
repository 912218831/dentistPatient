//
//  RecommandDoctorModel.h
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseModel.h"

@interface RecommandDoctorModel : BaseModel
@property (nonatomic, copy) NSString *dentistId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *descrip;
@property (nonatomic, copy) NSString *headImgUrl;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *clinicName;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic) CLLocationCoordinate2D coordinated2D;
@end
