//
//  HWTabbBarViewController.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/7/25.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "RDVTabBarController.h"
#import "HWTabbarViewModel.h"
@interface HWTabBarViewController : RDVTabBarController
@property(strong,nonatomic)HWTabbarViewModel * viewModel;
- (instancetype)initWithViewModel:(HWTabbarViewModel *)viewModel;
@end
