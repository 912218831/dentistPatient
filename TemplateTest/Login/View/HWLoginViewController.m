//
//  HWLoginViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/7/27.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWLoginViewController.h"
#import <YYText.h>
#import <NSString+YYAdd.h>
#import <YYModel/YYModel.h>
#import "HWLoginTranstionAnimation.h"
#import "HWLoginTranstionAnimationRevert.h"
#import "HWCustomDrawImg.h"
#import "HWLoginViewModel.h"
#import "HWLoginTelphoneCell.h"
@interface HWLoginViewController ()<UIViewControllerTransitioningDelegate,UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView * table;
@property(strong,nonatomic)UIButton * loginBtn;
@property(strong,nonatomic)HWLoginViewModel *viewModel;
@end

@implementation HWLoginViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView  = [Utility navTitleView:@"手机号登录"];
}

- (void)configContentView {
    [super configContentView];
    
    [self addSubview:self.table];
}

- (void)bindViewModel {
    [super bindViewModel];
}

- (UITableView *)table
{
    if (_table == nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_table registerNib:[UINib nibWithNibName:@"HWLoginTelphoneCell" bundle:nil] forCellReuseIdentifier:@"loginTelPhoneCell"];
        UIImageView * bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT)];
        bgImgV.contentMode = UIViewContentModeScaleToFill;
        bgImgV.image = [UIImage imageNamed:@"loginBG.png"];
        _table.tableHeaderView = [self tableViewHeaderView];
        _table.backgroundView = bgImgV;
        _table.tableFooterView = [self tableViewFooterView];
    }
    return _table;
}

- (UIView *)tableViewHeaderView
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRate(260))];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableViewFooterView{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, CONTENT_HEIGHT - kRate(260) - 115)];
    footerView.backgroundColor = [UIColor clearColor];
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, kRate(35), kScreenWidth - 30, 50)];
    [self.loginBtn setImage:[HWCustomDrawImg drawTextImg:CGSizeMake(kScreenWidth - 30, 50) backgroundColor:COLOR_FFFFFF content:@"登录" contentConfig:@{NSForegroundColorAttributeName:COLOR_144271,NSFontAttributeName:FONT(19)}] forState:UIControlStateNormal];
    [footerView addSubview:self.loginBtn];
    return footerView;
}

#pragma UITabelViewDelegate && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWLoginTelphoneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"loginTelPhoneCell" forIndexPath:indexPath];
    self.viewModel.loginCellModel = cell.viewModel;
    self.loginBtn.rac_command = self.viewModel.loginCommand;
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        //调试
        HWTabbarViewModel * tabbarViewModel = [[HWTabbarViewModel alloc] init];
        [[ViewControllersRouter shareInstance] presentViewModel:tabbarViewModel animated:YES completion:^(UIViewController *targetVC) {
            [SHARED_APP_DELEGATE.window setRootViewController:targetVC];
        }];

        
//        [self.viewModel.loginCommand execute:nil];
    }];
    [self.viewModel.loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        HWTabbarViewModel * tabbarViewModel = [[HWTabbarViewModel alloc] init];
        [[ViewControllersRouter shareInstance] presentViewModel:tabbarViewModel animated:YES completion:^(UIViewController *targetVC) {
            [SHARED_APP_DELEGATE.window setRootViewController:targetVC];
        }];
    }];
    [self.viewModel.loginCommand.errors subscribeNext:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility showToastWithMessage:error.localizedDescription];
        });
    }];

    return cell;
}

@end
