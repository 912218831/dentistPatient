//
//  BaseListViewController.m
//  MVVMFrame
//
//  Created by lizhongqiang on 16/7/28.
//  Copyright © 2016年 lizhongqiang. All rights reserved.
//

#import "BaseListViewController.h"
#import "BaseListViewModel.h"

@interface BaseListViewController () <UITableViewDataSource>
@property (nonatomic, strong, readwrite) UITableView   *listView;
@property (nonatomic, strong) BaseListViewModel *viewModel;
@end

@implementation BaseListViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configContentView {
    [super configContentView];
    
    self.listView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width, CONTENT_HEIGHT) style:UITableViewStylePlain];
    [self addSubview:self.listView];
    self.listView.dataSource = self;
    self.listView.delegate = self;
    self.listView.alwaysBounceVertical = true;
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listView.backgroundColor = self.view.backgroundColor;
}

- (void)bindViewModel {
    [super bindViewModel];
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

- (UITableViewCell *)tableViewCell:(NSIndexPath *)indexPath {
    return nil;
}

@end
