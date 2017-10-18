//
//  HWSettingViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//  设置

#import "HWSettingViewController.h"
#import "HWSettingViewModel.h"
@interface HWSettingViewController ()
@property(nonatomic,strong)HWSettingViewModel * viewModel;
@property(strong,nonatomic)UIButton * logoutBtn;
@end

@implementation HWSettingViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [Utility navTitleView:@"设置"];
}

- (void)configContentView
{
    [super configContentView];
    self.logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 20)];
    [self.logoutBtn setTintColor:[UIColor whiteColor]];
    [self.logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    self.logoutBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.logoutBtn];
}

- (void)bindViewModel
{
    self.logoutBtn.rac_command = self.viewModel.logoutCommand;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(HWTabBarViewController *)SHARED_APP_DELEGATE.viewController setTabBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [(HWTabBarViewController *)SHARED_APP_DELEGATE.viewController setTabBarHidden:YES animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
