//
//  HWAppointmentFailViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/13.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointmentFailViewController.h"
#import "HWAppointFailViewModel.h"
#import "HWAppoitmentFailCell.h"
#import <MJRefresh/MJRefresh.h>
@interface HWAppointmentFailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView * table;
@property(strong,nonatomic)HWAppointFailViewModel * viewModel;
@property(strong,nonatomic)UIButton * cancelBtn;
@property(strong,nonatomic)UIButton * answerBtn;//问答
@property(strong,nonatomic)UIImageView * headerImgV;

@end

@implementation HWAppointmentFailViewController
@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)configContentView
{
    [super configContentView];
    [self.view addSubview:self.table];

    [self configTableViewHeaderAndFooter];
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.table.bottom, kScreenWidth, 50)];
    [self.cancelBtn setTitle:@"取消预约" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    self.cancelBtn.backgroundColor = COLOR_28BEFF;
    [self.view addSubview:self.cancelBtn];
    self.answerBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 0, 50, 32)];
    self.answerBtn.bottom = self.cancelBtn.top - 10;
    self.answerBtn.contentMode = UIViewContentModeCenter;
    [self.answerBtn setImage:ImgWithName(@"answer") forState:UIControlStateNormal];
    [self.view addSubview:self.answerBtn];
}

- (UITableView *)table
{
    if (_table == nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT-50) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerNib:[UINib nibWithNibName:@"HWAppoitmentFailCell" bundle:nil] forCellReuseIdentifier:@"HWAppoitmentFailCell"];
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT)];
        self.headerImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, kRate(117), kRate(150))];
        self.headerImgV.centerX = kScreenWidth/2.0f;
//        self.headerImgV.image = ImgWithName(@"我的预约bg");
        [bg addSubview:self.headerImgV];
        _table.backgroundView = bg;
    }
    
    return _table;
}

- (void)configTableViewHeaderAndFooter{
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRate(168))];
    header.backgroundColor = [UIColor clearColor];
    self.table.tableHeaderView = header;
    
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRate(100))];
//    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, kRate(100))];
//    lab.text = @"医生会尽量跟你联系确定时间";
//    lab.font = FONT(14.0f);
//    lab.textColor = COLOR_999999;
//    lab.textAlignment = NSTextAlignmentCenter;
//    [footer addSubview:lab];
    self.table.tableFooterView = footer;
}

#pragma UITableView delegate && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 270;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWAppoitmentFailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HWAppoitmentFailCell"];
    @weakify(self);
    [[cell.acceptBtn.rac_command.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSString * x) {
        @strongify(self);
        if ([x isEqualToString:@"采纳医生建议"]) {
            [Utility hideMBProgress:self.view];
            [Utility showToastWithMessage:x];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[ViewControllersRouter shareInstance] popViewModelAnimated:YES];
            });
        }
        else
        {
            [Utility showMBProgress:self.view message:x];
        }
    }];
    [[cell.acceptBtn.rac_command errors] subscribeNext:^(NSError * error) {
        @strongify(self);
        [Utility showToastWithMessage:error.localizedDescription];
        [Utility hideMBProgress:self.view];
    }];
    [cell bindViewModel:self.viewModel];
    return cell;
}


- (void)bindViewModel
{
    [super bindViewModel];
    [self.viewModel bindViewWithSignal];
    [self.viewModel.requestSignal subscribeNext:^(id x) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.headerImgV sd_setImageWithURL:[NSURL URLWithString:self.viewModel.detailModel.headImgUrl] placeholderImage:ImgWithName(@"我的预约bg")];
            [self.table reloadData];
        });
    } error:^(NSError *error) {
        [Utility showToastWithMessage:error.localizedDescription];
    }];
    [self.viewModel execute];
    self.cancelBtn.rac_command = self.viewModel.cancelCommand;
    [[self.cancelBtn.rac_command.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSString * x) {
        if ([x isEqualToString:@"取消预约"]) {
            [Utility hideMBProgress:self.view];
            [Utility showToastWithMessage:x];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[ViewControllersRouter shareInstance] popViewModelAnimated:YES];
            });
            
        }
        else
        {
            [Utility showMBProgress:self.view message:x];
            
        }
        
    }];
    [[[self.cancelBtn.rac_command  errors] deliverOnMainThread] subscribeNext:^(NSError * x) {
        [Utility hideMBProgress:self.view];
        [Utility showToastWithMessage:x.localizedDescription];
    }];
    self.answerBtn.rac_command = self.viewModel.answerCommand;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
