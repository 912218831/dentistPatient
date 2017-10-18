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
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[HWUserLogin currentUserLogin] userLogout];
                HWLoginViewModel * viewModel = [HWLoginViewModel new];
                HWLoginViewController * loginCtrl = [[HWLoginViewController alloc] initWithViewModel:viewModel];
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:loginCtrl];
                nav.view.backgroundColor = [UIColor whiteColor];
                [(SHARED_APP_DELEGATE).window.rootViewController presentViewController:nav animated:YES completion:^{
                    [SHARED_APP_DELEGATE.window setRootViewController:nav];
                }];
                
            });

            return [RACSignal empty];
        }];
    }
    return self;
}

@end
