//
//  HWCitySelectViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/25.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWCitySelectViewController.h"
#import "HWCityModel_CD+CoreDataClass.h"
#import "HWCitySelectLocationCell.h"
#import "HWSelectCitySearchView.h"
@interface HWCitySelectViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>

@property(strong,nonatomic)NSFetchedResultsController * fetchController;
@property(strong,nonatomic)UITableView * table;

@end

@implementation HWCitySelectViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)configContentView
{
    [super configContentView];
    [self.view addSubview:self.table];
    [self configTableHeaderView];
    [self fetchDataWithCondition:nil];
}

- (void)configTableHeaderView
{
    HWSelectCitySearchView * header = [[[NSBundle mainBundle] loadNibNamed:@"HWSelectCitySearchView" owner:self options:nil] lastObject];
    [[header.searchTF.rac_textSignal skip:1] subscribeNext:^(id x) {
        
        [self fetchDataWithCondition:x];
    }];
    self.table.tableHeaderView = header;
}
- (UITableView *)table
{
    if (_table == nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerNib:[UINib nibWithNibName:@"HWCitySelectLocationCell" bundle:nil] forCellReuseIdentifier:@"HWCitySelectLocationCell"];
        [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    }
    return _table;
}


- (void)fetchDataWithCondition:(NSString *)condition{
    NSError *error = nil;
    if (condition.length == 0 || condition == nil) {
        self.fetchController = [HWCityModel_CD MR_fetchAllSortedBy:@"pinyin" ascending:YES withPredicate:nil groupBy:@"cityFirstChar" delegate:self];
        
        self.fetchController.delegate = self;

    }
    else
    {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"pinyin CONTAINS %@",condition];
        
        self.fetchController = [HWCityModel_CD MR_fetchAllSortedBy:@"pinyin" ascending:YES withPredicate:predicate groupBy:@"cityFirstChar" delegate:self];
    }
    [self.fetchController performFetch:&error];
    if (error) {
        
    }
    else
    {
        [self.table reloadData];
    }
}

#pragma UITableViewDelegate  && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchController sections].count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchController sections][section-1];
        return [sectionInfo numberOfObjects];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"定位城市";
    }
    else
    {
        id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchController sections][section-1];
        return sectionInfo.name;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [tableView dequeueReusableCellWithIdentifier:@"HWCitySelectLocationCell"];
    }
    else
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
        NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
        HWCityModel_CD * cityModel = [self.fetchController objectAtIndexPath:newIndexPath];
        cell.textLabel.text = cityModel.name;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
    HWCityModel_CD * cityModel = [self.fetchController objectAtIndexPath:newIndexPath];
    [[AppShare shareInstance] handelCurrentCoreDataLoginUser:^(HWLoginUser *loginUser) {
        loginUser.cityId = cityModel.cityId;
        loginUser.cityName = cityModel.name;
    }];
    [[ViewControllersRouter shareInstance] popViewModelAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
