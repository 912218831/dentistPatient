//
//  HWTabbarViewModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWTabbarViewModel.h"

@implementation HWTabbarViewModel
- (instancetype)init {
    if (self = [super init]) {
        self.homePageViewModel = [HWHomePageViewModel new];
        self.appointViewModel = [HWAppointmentViewModel new];
        self.casesViewModel = [HWCasesViewModel new];
        self.settingViewModel = [HWPeopleCenterViewModel new];
    }
    return self;
}
@end
