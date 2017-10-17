//
//  HWAppointFinishViewModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/10/13.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseViewModel.h"
#import "HWAppointDetailModel.h"

@interface HWAppointFinishViewModel : BaseViewModel
@property(strong,nonatomic,readonly)HWAppointDetailModel * detailModel;
@property(strong,nonatomic)RACCommand * answerCommand;

- (instancetype)initWithAppointId:(NSString *)appointId;

@end
