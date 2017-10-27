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
#import "DoctorAbstractInfoView.h"

@interface HWLoginViewController ()<UIViewControllerTransitioningDelegate,UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView * table;
@property(strong,nonatomic)UIButton * loginBtn;
@property(strong,nonatomic)HWLoginViewModel *viewModel;
@property(strong,nonatomic)DoctorAbstractButton *wechatBtn;
@end

@implementation HWLoginViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)configContentView {
    [super configContentView];
    
    switch (self.viewModel.type) {
        case Login:
        {
            self.navigationItem.titleView  = [Utility navTitleView:@"手机号登录"];
        }
            break;
        case Bind:
        {
            self.navigationItem.titleView  = [Utility navTitleView:@"绑定手机号"];
            self.navigationItem.leftBarButtonItem = [Utility navButton:self action:@selector(backMethod) image:[UIImage imageNamed:@"TOP_ARROW"]];
        }
            break;
        default:
            break;
    }
    
    [self addSubview:self.table];
    [[RACScheduler mainThreadScheduler]schedule:^{
        [self.table setContentOffset:CGPointMake(0, self.table.contentSize.height-self.table.height)];
    }];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [[self.wechatBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        loginAction();
    }];
    if (self.viewModel.type == Login) {
        [WechatDelegate shareWechatDelegate].getInfoSuccess = ^{
            @strongify(self);
            [Utility showMBProgress:self.contentView message:nil];
            [self.viewModel wechatLogin:^(NSString *error) {
                [Utility hideMBProgress:self.contentView];
                if (error) {
                    [Utility showToastWithMessage:error];
                } else {
                    if (self.viewModel.firstFlag) {
                        HWLoginViewModel *vm = [HWLoginViewModel new];
                        vm.type = Bind;
                        [[ViewControllersRouter shareInstance]pushViewModel:vm animated:true];
                    } else {
                        [self resetRootViewController];
                    }
                }
            }];
            
        };
    }
}

- (UITableView *)table
{
    if (_table == nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT) style:UITableViewStylePlain];
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
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT - kRate(260+55) )];
    footerView.backgroundColor = [UIColor clearColor];
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, kRate(35), kScreenWidth - 30, 50)];
    [self.loginBtn setImage:[HWCustomDrawImg drawTextImg:CGSizeMake(kScreenWidth - 30, 50) backgroundColor:COLOR_FFFFFF content:(self.viewModel.type==Login?@"登录":@"下一步") contentConfig:@{NSForegroundColorAttributeName:COLOR_144271,NSFontAttributeName:FONT(19)}] forState:UIControlStateNormal];
    [footerView addSubview:self.loginBtn];
    
    if (self.viewModel.type == Login) {
        self.wechatBtn = [DoctorAbstractButton buttonWithType:UIButtonTypeCustom];
        [footerView addSubview:self.wechatBtn];
        CGSize wechatSize = CGSizeMake(kRate(74), kRate(73));
        self.wechatBtn.frame = CGRectMake((footerView.width-wechatSize.width)/2.0, (footerView.height)-(kRate(25)+wechatSize.height), wechatSize.width, wechatSize.height);
        [self.wechatBtn setImage:[UIImage imageNamed:@"wechatIcon"] forState:UIControlStateNormal];
        [self.wechatBtn setTitle:@"微信登录" forState:UIControlStateNormal];
        [self.wechatBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
        self.wechatBtn.titleLabel.font = FONT(TF14);
        self.wechatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.wechatBtn.imageFrame = CGRectMake((wechatSize.width-kRate(42))/2.0, 0, kRate(42), kRate(42));
        self.wechatBtn.titleFrame = CGRectMake(0, wechatSize.height - TF14, wechatSize.width, TF14);
    }
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
    @weakify(self);
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.loginCommand execute:nil];
    }];
   
    [self.viewModel.loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self resetRootViewController];
    }];
    [self.viewModel.loginCommand.errors subscribeNext:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility showToastWithMessage:error.localizedDescription];
        });
    }];

    return cell;
}

- (void)resetRootViewController {
    HWTabbarViewModel * tabbarViewModel = [[HWTabbarViewModel alloc] init];
    SHARED_APP_DELEGATE.viewController = [[HWTabBarViewController alloc] initWithViewModel:tabbarViewModel];
    
    [SHARED_APP_DELEGATE.window.rootViewController presentViewController:SHARED_APP_DELEGATE.viewController animated:YES completion:^{
        
        if (SHARED_APP_DELEGATE.window.rootViewController.presentingViewController) {
            [SHARED_APP_DELEGATE.window.rootViewController.presentingViewController dismissViewControllerAnimated:false completion:^{
                [SHARED_APP_DELEGATE.window setRootViewController:SHARED_APP_DELEGATE.viewController];
            }];
            
        }
        else
        {
            [SHARED_APP_DELEGATE.window setRootViewController:SHARED_APP_DELEGATE.viewController];
        }
        
    }];
}

@end
