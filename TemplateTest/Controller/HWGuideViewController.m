//
//  HWGuideViewController.m
//  RDVTabBarController
//
//  Created by 杨庆龙 on 2017/7/27.
//  Copyright © 2017年 Robert Dimitrov. All rights reserved.
//

#import "HWGuideViewController.h"
#import "AppDelegate.h"
#import "HWLoginViewModel.h"

@interface HWGuideViewController ()

@end

@implementation HWGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isGuide) {
        //显示引导页
    }
    else
    {
        //推出登录页
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imgV.image = [UIImage imageNamed:@"启动页"];
        [self.view addSubview:imgV];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentLoginViewController];
        });
    }
    
}

- (void)presentLoginViewController
{
    HWLoginViewModel *viewModel = [HWLoginViewModel new];
    [[ViewControllersRouter shareInstance]presentViewModel:viewModel animated:_isGuide completion:^(id targetVC) {
        if (![targetVC isKindOfClass:[UINavigationController class]]) {
            [SHARED_APP_DELEGATE.window setRootViewController:[[HWBaseNavigationController alloc] initWithRootViewController:targetVC]];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end