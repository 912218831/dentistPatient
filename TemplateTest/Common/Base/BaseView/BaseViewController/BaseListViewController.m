//
//  BaseListViewController.m
//  MVVMFrame
//
//  Created by lizhongqiang on 16/7/28.
//  Copyright © 2016年 lizhongqiang. All rights reserved.
//

#import "BaseListViewController.h"
#import "BaseListViewModel.h"

@interface BaseListViewController () <UITableViewDataSource,
                                     HWBaseRefreshViewObserverProtocol>
@property (nonatomic, strong, readwrite) HWBaseRefreshView   *listView;
@property (nonatomic, strong) BaseListViewModel *viewModel;
@end

@implementation BaseListViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configContentView {
    [super configContentView];
    
    self.listView = [[HWBaseRefreshView alloc]initWithFrame:self.view.bounds];
    [self addSubview:self.listView];
    self.listView.baseTable.dataSource = self;
    self.listView.baseTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listView.isLastPage = true;
    self.listView.currentPage = 1;
    self.listView.isNeedHeadRefresh = true;
    self.listView.observer = self;
    self.listView.backgroundColor = self.view.backgroundColor;
}

- (void)sendAction:(NSString *)selectorString {
    self.viewModel.currentPage = self.listView.currentPage;
    [self.viewModel setActive:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(tableViewCell:)]) {
        return [self tableViewCell:indexPath];
    }
    return nil;
}

- (void)reloadviewWhenDatasourceChange {
    [self.listView.baseTable reloadData];
}

- (UITableViewCell *)tableViewCell:(NSIndexPath *)indexPath {
    return nil;
}

@end