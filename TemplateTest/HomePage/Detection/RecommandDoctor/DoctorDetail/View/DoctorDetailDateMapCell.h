//
//  DoctorDetailDateMapCell.h
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseListViewCell.h"
#import "PatientDetailDateView.h"

@interface DoctorDetailDateMapCell : BaseListViewCell
@property (nonatomic, strong) RACSignal *datesSignal;
@property (nonatomic, strong, readonly) PatientDetailDateView *dateView;
@end
