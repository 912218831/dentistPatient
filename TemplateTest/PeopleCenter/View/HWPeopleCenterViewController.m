//
//  HWPeopleCenterViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/7/25.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWPeopleCenterViewController.h"
#import "HWPeopleCenterViewModel.h"
#import "HWLoginViewController.h"
#import "HWPeopleCenterHeadView.h"
#import "HWPeopleCenterCell.h"

@interface HWPeopleCenterViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) HWPeopleCenterViewModel *viewModel;
@property (nonatomic, strong) UIScrollView *listView;
@property (nonatomic, strong) HWPeopleCenterHeadView *headView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HWPeopleCenterCell *cell;
@property (nonatomic, strong) UIButton *logoutBtn;
@end

@implementation HWPeopleCenterViewController
@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(HWTabBarViewController *)SHARED_APP_DELEGATE.viewController setTabBarHidden:NO animated:YES];
    [self.navigationController setNavigationBarHidden:true animated:true];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [(HWTabBarViewController *)SHARED_APP_DELEGATE.viewController setTabBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.listView.contentInset = UIEdgeInsetsZero;
}

- (void)bindViewModel {
    [super bindViewModel];
    [self.viewModel bindViewWithSignal];
    
    // 请求个人信息
    [self.viewModel.requestSignal  subscribeError:^(NSError *error) {
        [Utility showToastWithMessage:error.domain];
    } completed:^{
        [self.headView.headerImageView sd_setImageWithURL:self.viewModel.headImageUrl placeholderImage:[UIImage imageNamed:@"selectPeople"]];
        self.headView.phoneLabel.text = self.viewModel.userPhone;
        self.headView.nameLabel.text = self.viewModel.userName;
        [self.headView.scoreBtn setTitle:[NSString stringWithFormat:@"积分%@",self.viewModel.model.score] forState:UIControlStateNormal];
        self.headView.scoreBtn.spaceX = self.headView.scoreBtn.spaceX;
    }];
    @weakify(self);
    // 退出登录绑定
    self.logoutBtn.rac_command = self.viewModel.loginOutCommand;
    // 积分点击事件绑定
    self.headView.scoreBtn.rac_command = self.viewModel.scoreTouch;
    
    // 退出登录
    [self.viewModel.loginOutCommand.executionSignals.newSwitchToLatest subscribeNext:^(id x) {
        [[ViewControllersRouter shareInstance]setRootViewController:@"LoginViewModel"];
    } error:nil completed:nil];
    
    [[self.viewModel.loginOutCommand.executing skip:1] subscribeNext:^(NSNumber *x) {
        if (x.boolValue) {
            [Utility showMBProgress:self.contentView message:nil];
        } else {
            [Utility hideMBProgress:self.contentView];
        }
    }];
    
    [self.viewModel.loginOutCommand.errors subscribeNext:^(NSError *x) {
        [Utility showToastWithMessage:x.domain];
    }];
    
    self.cell.touchEvent = ^(EventType type) {
        @strongify(self);
        switch (type) {
            case ChangePW:
            {// 修改密码
                [self.viewModel.setPassword execute:nil];
            }
                break;
            case Family:
            {// 我的家庭
                [self.viewModel.familyJump execute:nil];
            }
                break;
            case Setting:
            {
                [self.viewModel.setting execute:nil];
            }
                break;
            default:
                break;
        }
    };
}

- (void)configContentView {
    [super configContentView];
    
    self.listView = [[UIScrollView alloc]initWithFrame:self.bounds];
    if (@available(iOS 11.0, *)) {
        self.listView.top = -20;
    }
    self.listView.delegate = self;
    self.listView.contentSize = self.bounds.size;
    self.listView.alwaysBounceVertical = true;
    [self addSubview:self.listView];
    self.listView.backgroundColor = CD_LIGHT_BACKGROUND;
    
    self.headView = [[HWPeopleCenterHeadView alloc]init];
    self.headView.frame = CGRectMake(0, 0, self.listView.width, kRate(249));
    [self.listView addSubview:self.headView];
    
    HWPeopleCenterCell *cell = [[HWPeopleCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    cell.frame = CGRectMake(0, kRate(249), self.listView.width, kRate(150));
    [self.listView addSubview:cell];
    self.cell = cell;
    
    self.titleLabel = [UILabel new];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = BOLDFONT(19);
    self.titleLabel.textColor = COLOR_FFFFFF;
    self.titleLabel.text = @"设置";
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(20);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(44);
    }];
    
    self.logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.listView addSubview:self.logoutBtn];
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_bottom).with.offset(kRate(56/2.0));
        make.left.mas_equalTo(kRate(33));
        make.width.mas_equalTo(self.listView.width-kRate(66));
        make.height.mas_equalTo(kRate(40));
    }];
    self.logoutBtn.backgroundColor = UIColorFromRGB(0xfa6c36);
    [self.logoutBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    [self.logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    self.logoutBtn.titleLabel.font = FONT(TF16);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
