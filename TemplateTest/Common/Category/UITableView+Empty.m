//
//  UITableView+Empty.m
//  TemplateTest
//
//  Created by HW on 2017/10/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "UITableView+Empty.h"

#define kEmptyTag 100

@implementation UITableView (Empty)

- (void)setNeedShowEmpty:(BOOL)needShowEmpty {
    objc_setAssociatedObject(self, _cmd, @(needShowEmpty), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (needShowEmpty) {
        @weakify(self);
        [[self rac_signalForSelector:@selector(reloadData)]subscribeNext:^(id x) {
            @strongify(self);
            if (self.dataSource) {
               NSInteger n = [self.dataSource tableView:self numberOfRowsInSection:0];
                if (n) {
                    [self hideEmptyView];
                } else {
                    [self showEmptyView];
                }
            }
        }];
    }
}

- (BOOL)needShowEmpty {
    id value = objc_getAssociatedObject(self, @selector(setNeedShowEmpty:));
    return [value boolValue];
}

- (void)hideEmptyView {
    UIView *em = [self viewWithTag:kEmptyTag];
    [em removeFromSuperview];
}

- (void)showEmptyView {
    UILabel *label = [self viewWithTag:kEmptyTag];
    if (!label) {
        label = [UILabel new];
        label.text = @"暂无数据";
        label.textColor = CD_Text99;
        label.font = FONT(kRate(TF15));
        label.tag = kEmptyTag;
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    } else {
        [self bringSubviewToFront:label];
    }
}

@end
