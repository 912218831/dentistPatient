//
//  HWTabbarViewModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseViewModel.h"
#import "HWHomePageViewModel.h"
#import "HWCasesViewModel.h"
#import "HWAppointmentViewModel.h"
#import "HWPeopleCenterViewModel.h"
@interface HWTabbarViewModel : BaseViewModel
@property(strong,nonatomic)HWHomePageViewModel * homePageViewModel;
@property(strong,nonatomic)HWCasesViewModel * casesViewModel;
@property(strong,nonatomic)HWAppointmentViewModel * appointViewModel;
@property(strong,nonatomic)HWPeopleCenterViewModel * settingViewModel;

@end
