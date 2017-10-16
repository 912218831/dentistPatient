//
//  HWAppointmentViewModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseViewModel.h"

@interface HWAppointmentViewModel : BaseViewModel
@property(strong,nonatomic)RACCommand * itemClickCommand;
@property(assign,nonatomic)BOOL  isNeedRefresh;
@property(copy,nonatomic)NSString * currentPage;
@property(assign,nonatomic)BOOL  isLastPage;


@end
