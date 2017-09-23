//
//  HWAppointFailViewModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/21.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseViewModel.h"
#import "HWAppointDetailModel.h"
@interface HWAppointFailViewModel : BaseViewModel
@property(strong,nonatomic,readonly)HWAppointDetailModel * detailModel;
@property(strong,nonatomic)RACCommand * acceptCommand;
@property(strong,nonatomic)RACCommand * rejectCommand;
@property(strong,nonatomic)RACCommand * cancelCommand;

- (instancetype)initWithAppointId:(NSString *)appointId;

@end
