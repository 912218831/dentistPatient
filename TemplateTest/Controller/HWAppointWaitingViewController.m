//
//  HWAppointWaitingViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/14.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointWaitingViewController.h"
#import "HWAppointWaitingCell.h"
@interface HWAppointWaitingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView * table;

@end

@implementation HWAppointWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table];
}

- (UITableView *)table
{
    if (_table == nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerNib:[UINib nibWithNibName:@"HWAppointWaitingCell" bundle:nil] forCellReuseIdentifier:@"HWAppointWaitingCell"];
    }
    
    return _table;
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
    return [tableView dequeueReusableCellWithIdentifier:@"HWAppointWaitingCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
