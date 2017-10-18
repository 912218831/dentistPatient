//
//  HWSettingViewModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWSettingViewModel.h"
#import "HWLoginViewController.h"
#import "HWLoginViewModel.h"
@implementation HWSettingViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.logoutCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            [[AppShare shareInstance] logout];
            return [RACSignal empty];
        }];
    }
    return self;
}

@end
