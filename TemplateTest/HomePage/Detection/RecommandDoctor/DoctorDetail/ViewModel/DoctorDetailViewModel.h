//
//  DoctorDetailViewModel.h
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseListViewModel.h"
#import "RecommandDoctorModel.h"
#import "DoctorDetailModel.h"

@interface DoctorDetailViewModel : BaseListViewModel
@property (nonatomic, strong) MAPointAnnotation *annotation;
@property (nonatomic, strong) RecommandDoctorModel *doctorModel;
@property (nonatomic, assign) CGFloat timesHeight;
@property (nonatomic, strong) NSIndexPath *selectDateIndexPath;
@end
