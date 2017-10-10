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
    self.cancelBtn.backgroundColor = COLOR_B5C8D9;
    [self.view addSubview:self.cancelBtn];
    
    self.table.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        
        NSLog(@"刷新");
        [self.table.mj_header endRefreshing];
    }];

}

- (UITableView *)table
{
    if (_table == nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT-50) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerNib:[UINib nibWithNibName:@"HWAppoitmentFailCell" bundle:nil] forCellReuseIdentifier:@"HWAppoitmentFailCell"];
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT)];
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, kRate(117), kRate(150))];
        imgV.centerX = kScreenWidth/2.0f;
        imgV.image = ImgWithName(@"我的预约bg");
        [bg addSubview:imgV];
        _table.backgroundView = bg;
    }
    
    return _table;
}

- (void)configTableViewHeaderAndFooter{
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRate(168))];
    header.backgroundColor = [UIColor clearColor];
    self.table.tableHeaderView = header;
    
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRate(100))];
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, kRate(100))];
    lab.text = @"医生会尽量跟你联系确定时间";
    lab.font = FONT(14.0f);
    lab.textColor = COLOR_999999;
    lab.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:lab];
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
        [Utility showMBProgress:self.view message:x];
    } completed:^{
        @strongify(self);
        [Utility hideMBProgress:self.view];
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
            [self.table reloadData];
        });
    } error:^(NSError *error) {
        [Utility showToastWithMessage:error.localizedDescription];
    }];
    [self.viewModel execute];
    self.cancelBtn.rac_command = self.viewModel.cancelCommand;
    [[self.cancelBtn.rac_command.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSString * x) {
        [Utility showMBProgress:self.view message:x];
    } completed:^{
        [Utility hideMBProgress:self.view];
    }];
    [[[self.cancelBtn.rac_command  errors] deliverOnMainThread] subscribeNext:^(NSError * x) {
        [Utility hideMBProgress:self.view];
        [Utility showToastWithMessage:x.localizedDescription];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
