//
//  HWPeopleCenterModel.h
//  TemplateTest
//
//  Created by HW on 2017/10/18.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseModel.h"

@interface HWPeopleCenterModel : BaseModel
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headimage;
@property (nonatomic, copy) NSString *resistDate;
@property (nonatomic, copy) NSString *patientName;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *patientSex;
@property (nonatomic, copy) NSString *birthYear;
@property (nonatomic, copy) NSString *familyId;
@property (nonatomic, copy) NSString *score;
@end
