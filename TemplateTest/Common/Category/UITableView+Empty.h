//
//  UITableView+Empty.h
//  TemplateTest
//
//  Created by HW on 2017/10/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Empty)
@property (nonatomic, assign) BOOL needShowEmpty;// default - false
- (void)showEmptyView;
- (void)hideEmptyView;
@end
