//
//  BaseListViewController.h
//  MVVMFrame
//
//  Created by lizhongqiang on 16/7/28.
//  Copyright © 2016年 lizhongqiang. All rights reserved.
//

#import "BaseViewController.h"
#import  "HWBaseRefreshView.h"

@interface BaseListViewController : BaseViewController
@property (nonatomic, strong, readonly) HWBaseRefreshView   *listView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableViewCell:(NSIndexPath *)indexPath;
@end
