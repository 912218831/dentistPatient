//
//  HWAppointWaitingViewModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/21.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseViewModel.h"
#import "HWAppointDetailModel.h"
@interface HWAppointWaitingViewModel : BaseViewModel
@property(strong,nonatomic,readonly)HWAppointDetailModel * detailModel;
@property(strong,nonatomic)RACCommand * cancelCommand;
@property(strong,nonatomic)RACCommand * answerCommand;
- (instancetype)initWithAppointId:(NSString *)appointId;

@end
