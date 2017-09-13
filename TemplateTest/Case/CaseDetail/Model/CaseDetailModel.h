//
//  CaseDetailModel.h
//  TemplateTest
//
//  Created by HW on 17/9/13.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseModel.h"
#import "CaseDetailImageModel.h"

@interface CaseDetailModel : BaseModel
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *patintId;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) NSInteger machineReport;
@property (nonatomic, copy) NSString *patintName;
@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *doctor;
@property (nonatomic, copy) NSString *clinicName;
@property (nonatomic, strong) NSArray *images;
@end
