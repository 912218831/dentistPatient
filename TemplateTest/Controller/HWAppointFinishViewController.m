//
//  HWAppointFinishViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/10/13.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointFinishViewController.h"
#import "HWAppointFinishViewModel.h"
#import "HWAppointFinishCell.h"
#import "HWAppointDetailModel.h"
@interface HWAppointFinishViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView * table;
@property(strong,nonatomic)UIButton * cancelBtn;
@property(strong,nonatomic)HWAppointFinishViewModel * viewModel;
@property(strong,nonatomic)UIButton * answerBtn;
@property(strong,nonatomic)UIImageView * headerImgV;
@end

@implementation HWAppointFinishViewController
@dynamic viewModel;
- (void)configContentView
{
    [super configContentView];
    [self.view addSubview:self.table];
    [self configTableViewHeaderAndFooter];
    self.answerBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50, CONTENT_HEIGHT - 16 - 50, 50, 32)];
    self.answerBtn.contentMode = UIViewContentModeCenter;
    [self.answerBtn setImage:ImgWithName(@"answer") forState:UIControlStateNormal];
    [self.view addSubview:self.answerBtn];
    
}

- (UITableView *)table
{
    if (_table == nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerNib:[UINib nibWithNibName:@"HWAppointFinishCell" bundle:nil] forCellReuseIdentifier:@"HWAppointFinishCell"];
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT)];
        self.headerImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, kRate(117), kRate(150))];
        self.headerImgV.centerX = kScreenWidth/2.0f;
        self.headerImgV.image = ImgWithName(@"我的预约bg");
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
    HWAppointFinishCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HWAppointFinishCell"];
    [cell bindViewModel:self.viewModel];
    return cell;
}

- (void)bindViewModel
{
    [super bindViewModel];
    [self.viewModel initRequestSignal];
    [[self.viewModel.requestSignal deliverOnMainThread] subscribeNext:^(NSString * x) {
        [Utility showMBProgress:self.view message:x];
    } error:^(NSError *error) {
        [Utility hideMBProgress:self.view];
        [Utility showToastWithMessage:error.localizedDescription];
    } completed:^{
        [Utility hideMBProgress:self.view];
        [self.table reloadData];
        [self.headerImgV sd_setImageWithURL:[NSURL URLWithString:self.viewModel.detailModel.headImgUrl] placeholderImage:ImgWithName(@"我的预约bg")];

    }];
    [self.viewModel execute];
    self.answerBtn.rac_command = self.viewModel.answerCommand;
}

@end
