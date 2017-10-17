//
//  BaseListViewController.h
//  MVVMFrame
//
//  Created by lizhongqiang on 16/7/28.
//  Copyright © 2016年 lizhongqiang. All rights reserved.
//

#import "BaseViewController.h"
#import  "HWBaseRefreshView.h"

@interface BaseListViewController : BaseViewController <UITableViewDelegate>
@property (nonatomic, strong, readonly) UITableView   *listView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableViewCell:(NSIndexPath *)indexPath;
@end
