//
//  HWAppointWaitingViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/14.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointWaitingViewController.h"
#import "HWAppointWaitingCell.h"
#import "HWAppointWaitingViewModel.h"
@interface HWAppointWaitingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView * table;
@property(strong,nonatomic)UIButton * cancelBtn;
@property(strong,nonatomic)HWAppointWaitingViewModel * viewModel;

@end

@implementation HWAppointWaitingViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table];
    [self configTableViewHeaderAndFooter];
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.table.bottom, kScreenWidth, 50)];
    [self.cancelBtn setTitle:@"取消预约" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    self.cancelBtn.backgroundColor = COLOR_B5C8D9;
    [self.view addSubview:self.cancelBtn];

}

- (UITableView *)table
{
    if (_table == nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT-50) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerNib:[UINib nibWithNibName:@"HWAppointWaitingCell" bundle:nil] forCellReuseIdentifier:@"HWAppointWaitingCell"];
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
    footer.backgroundColor = [UIColor clearColor];
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
    return 237;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWAppointWaitingCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HWAppointWaitingCell"];
    [cell bindViewModel:self.viewModel];
    return cell;
}

- (void)bindViewModel
{
    [super bindViewModel];
    [self.viewModel initRequestSignal];
    [self.viewModel.requestSignal subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.table reloadData];
        });

    } error:^(NSError *error) {
        [Utility showToastWithMessage:error.localizedDescription];
    }];
    [self.viewModel execute];
    self.cancelBtn.rac_command = self.viewModel.cancelCommand;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end