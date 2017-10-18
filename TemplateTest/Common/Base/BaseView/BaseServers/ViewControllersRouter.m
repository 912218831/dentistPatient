//
//  ViewControllersRouter.m
//  MVVMFrame
//
//  Created by lizhongqiang on 16/7/28.
//  Copyright © 2016年 lizhongqiang. All rights reserved.
//

#import "ViewControllersRouter.h"
#import "HWTabBarViewController.h"
#import "HWGuideViewController.h"
#import "BaseViewController.h"

@implementation ViewControllersRouter
static ViewControllersRouter *router;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (router == nil) {
            router = [[self alloc]init];
        }
    });
    return router;
}

#pragma mark -- ViewModel 映射

- (Class)classNameForViewModel:(NSString *)viewModelName {
    NSDictionary *maps = [self classWithViewMoldeMaps];
    return [maps objectForKey:viewModelName];
}

- (Class)viewControllerClassNameForViewModel:(NSString *)viewModelName {
    NSDictionary *maps = [self viewContollerWithViewMoldeMaps];
    return [maps objectForKey:viewModelName];
}

- (Class)classNameForDataSource:(NSString *)dataSourceName {
    NSDictionary *maps = [self viewContollerWithDataSourceMaps];
    return [maps objectForKey:dataSourceName];
}

- (Class)classNameForListView:(NSString *)listViewName {
    NSDictionary *maps = [self viewContollerWithListViewMaps];
    return [maps objectForKey:listViewName];
}

- (NSDictionary *)classWithViewMoldeMaps {
    return @{
             kLoginVM:objc_getClass(kLoginVM.UTF8String),
             kAppointFailVM:objc_getClass(kAppointFailVM.UTF8String),
             kAppointWaitingVM:objc_getClass(kAppointWaitingVM.UTF8String),
             kAppointSuccessVM:objc_getClass(kAppointSuccessVM.UTF8String),
             kAppointFinishVM:objc_getClass(kAppointFinishVM.UTF8String),
             kCaseDetailVM:objc_getClass(kCaseDetailVM.UTF8String),
             kDetectionVM:objc_getClass(kDetectionVM.UTF8String),
             kDetectionCaptureVM:objc_getClass(kDetectionCaptureVM.UTF8String),
             kDetectionResultVM:objc_getClass(kDetectionResultVM.UTF8String),
             kRDoctorVM:objc_getClass(kRDoctorVM.UTF8String),
             kRDoctorDetailVM:objc_getClass(kRDoctorDetailVM.UTF8String),
             kSelectCityVM:objc_getClass(kSelectCityVM.UTF8String),
             kBaseWebViewModel:objc_getClass(kBaseWebViewModel.UTF8String),
             kSetPasswordViewModel:objc_getClass(kSetPasswordViewModel.UTF8String)
             };
    
}

- (NSDictionary *)viewContollerWithViewMoldeMaps {
    return @{
             kLoginVM:objc_getClass("HWLoginViewController"),
             kTabbarVM:objc_getClass("HWTabBarViewController"),
             kHomePageVM:objc_getClass("HWHomePageViewController"),
             kCasesVM:objc_getClass("HWCasesViewController"),
             kCaseDetailVM:objc_getClass("CaseDetailViewController"),
             kAppointmentVM:objc_getClass("HWAppointmentViewController"),
             kAppointFailVM:objc_getClass("HWAppointmentFailViewController"),
             kAppointWaitingVM:objc_getClass("HWAppointWaitingViewController"),
             kAppointSuccessVM:objc_getClass("HWAppointSuccessViewController"),
             kAppointFinishVM:objc_getClass("HWAppointFinishViewController"),
             kSettingVM:objc_getClass("HWSettingViewController"),
             kDetectionVM:objc_getClass("HWDetectionSelectMemberViewController"),
             kDetectionCaptureVM:objc_getClass("DetectionCaptureViewController"),
             kDetectionResultVM:objc_getClass("DetectionResultViewController"),
             kRDoctorVM:objc_getClass("RecommandDoctorVC"),
             kRDoctorDetailVM:objc_getClass("DoctorDetailViewController"),
             kSelectCityVM:objc_getClass("HWCitySelectViewController"),
             kBaseWebViewModel:objc_getClass("BaseWebViewController"),
             kSetPasswordViewModel:objc_getClass("SetPasswordViewController")
             };
}

#pragma mark -- ViewController 映射 dataSource
- (NSDictionary *)viewContollerWithDataSourceMaps {
    return @{
             };
}
#pragma mark -- ViewController 映射 listView
- (NSDictionary *)viewContollerWithListViewMaps {
    return @{
             };
}

#pragma mark -- 根据 ViewModel 生成 Controller
- (UIViewController *)controllerMatchViewModel:(BaseViewModel *)viewModel {
    Class vcClass = [self viewControllerClassNameForViewModel:NSStringFromClass(viewModel.class)];
    BaseViewController *vc = [[vcClass alloc]initWithViewModel:viewModel];
    return vc;
}

- (void)setRootViewController:(NSString *)viewModelName {
    
    if ([viewModelName isEqualToString:@"tabbarViewModel"]) {
        HWTabbarViewModel * tabbarViewModel = [[HWTabbarViewModel alloc] init];
        HWTabBarViewController *tab = [[HWTabBarViewController alloc]initWithViewModel:tabbarViewModel];
        SHARED_APP_DELEGATE.viewController = tab;
        [SHARED_APP_DELEGATE.window setRootViewController:tab];
    }
    if ([viewModelName isEqualToString:@"LoginViewModel"]) {
//        Class viewModelClass = [self classNameForViewModel:viewModelName];
//        Class vcClass        = [self viewControllerClassNameForViewModel:viewModelName];
//        BaseViewModel *viewModel = [[viewModelClass alloc]init];
//
//        BaseViewController *login = [[vcClass alloc]initWithViewModel:viewModel];
//        HWBaseNavigationController *nav = [[HWBaseNavigationController alloc]initWithRootViewController:login];
//        SHARED_APP_DELEGATE.window.rootViewController = nav;
        HWGuideViewController *guide = [[HWGuideViewController alloc]init];
        guide.isGuide = NO;
        [SHARED_APP_DELEGATE.window setRootViewController:guide];

    }
    if ([viewModelName isEqualToString:@"GuideMainViewController"]) {
        
    }
}

- (void)luanchRootViewController {
    
    if(HWUserLogin.currentUserLogin.userkey.length){//
        // 主页
        [self setRootViewController:@"tabbarViewModel"];
    } else {
        // 登录页
        HWGuideViewController * guideCtrl = [[HWGuideViewController alloc] init];
        guideCtrl.isGuide = false;//[UserDefault share].isLaunched;
        [SHARED_APP_DELEGATE.window setRootViewController:guideCtrl];
        SHARED_APP_DELEGATE.isAutoLogin = NO;
    }
}

#pragma mark --- 跳转
- (UIViewController *)pushViewModel:(BaseViewModel *)viewModel animated:(BOOL)animated {
    UIViewController *vc = [BaseViewController currentViewController];
    Class vcClass = [self viewControllerClassNameForViewModel:NSStringFromClass(viewModel.class)];
    BaseViewController *baseVC = [[vcClass alloc]initWithViewModel:viewModel];
    [(HWTabBarViewController*)SHARED_APP_DELEGATE.viewController setTabBarHidden:true];
    [vc.navigationController pushViewController:baseVC animated:YES];
    
    return baseVC;
}

- (void)popViewModelAnimated:(BOOL)animated {
    UIViewController *vc = [BaseViewController currentViewController];
    [vc.navigationController popViewControllerAnimated:animated];
    if (vc.navigationController.viewControllers.count <= 1) {
        [(HWTabBarViewController*)SHARED_APP_DELEGATE.viewController setTabBarHidden:false];
    }
}

- (void)popToRootViewModelAnimated:(BOOL)animated {
    UIViewController *vc = [BaseViewController currentViewController];
    [vc.navigationController popToRootViewControllerAnimated:animated];
    [(HWTabBarViewController*)SHARED_APP_DELEGATE.viewController setTabBarHidden:false];
}

- (void)presentViewModel:(BaseViewModel *)viewModel animated:(BOOL)animated completion:(VoidBlock)completion {
    UIViewController *vc = [BaseViewController currentViewController];
    Class vcClass = [self viewControllerClassNameForViewModel:NSStringFromClass(viewModel.class)];
    
    BaseViewController *baseVC = [[vcClass alloc]initWithViewModel:viewModel];
    if ([baseVC isKindOfClass:objc_getClass("HWTabBarViewController")]) {
        SHARED_APP_DELEGATE.viewController = baseVC;
    }
    @weakify(baseVC);
    [SHARED_APP_DELEGATE.window.rootViewController presentViewController:baseVC animated:animated completion:^{
        @strongify(baseVC);
        completion(baseVC);
    }];
    
}

@end
