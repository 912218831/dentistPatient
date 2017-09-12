//
//  HWTabbBarViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/7/25.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWTabBarViewController.h"
#import "RDVTabBarItem.h"
#import "HWHomePageViewController.h"
#import "HWCasesViewController.h"
#import "HWAppointmentViewController.h"
#import "HWSettingViewController.h"

@interface HWTabBarViewController ()

@end

@implementation HWTabBarViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithViewModel:(HWTabbarViewModel *)viewModel
{
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        [self setUpControllers];

    }
    return self;
}

- (void)setUpControllers
{
    UIViewController *homePageController = [[HWHomePageViewController alloc] initWithViewModel:self.viewModel.homePageViewModel];
    
    UIViewController *caseViewController = [[HWCasesViewController alloc] initWithViewModel:self.viewModel.casesViewModel];
    
    UIViewController *appointmentViewController = [[HWAppointmentViewController alloc] initWithViewModel:self.viewModel.appointViewModel];
    UIViewController *settingViewController = [[HWSettingViewController alloc] initWithViewModel:self.viewModel.settingViewModel];
    
    HWBaseNavigationController * firstNav = [[HWBaseNavigationController alloc] initWithRootViewController:homePageController];
    HWBaseNavigationController * secondNav = [[HWBaseNavigationController alloc] initWithRootViewController:caseViewController];
    HWBaseNavigationController * thirdNav = [[HWBaseNavigationController alloc] initWithRootViewController:appointmentViewController];
    HWBaseNavigationController * fourNav = [[HWBaseNavigationController alloc] initWithRootViewController:settingViewController];
    
    [self setViewControllers:@[firstNav, secondNav,
                               thirdNav,fourNav]];
    [self customizeTabBarForController];

}

- (void)customizeTabBarForController{
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    
    NSArray *unSelectedImages = @[@"首页", @"订单", @"提成",@"我的"];
    NSArray * titles = @[@"首页",@"病例",@"我的预约",@"设置"];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"click%@",
                                                      [unSelectedImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[unSelectedImages objectAtIndex:index]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        item.title = [titles pObjectAtIndex:index];
        item.titlePositionAdjustment = UIOffsetMake(0, 5);
        index++;
    }
    [self customizeInterface];
}

- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName: [UIColor blackColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor: [UIColor blackColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

- (void)tabBar:(RDVTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index
{
    [super tabBar:tabBar didSelectItemAtIndex:index];
    
}

- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.titleView = [Utility navTitleView:@"总览"];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
