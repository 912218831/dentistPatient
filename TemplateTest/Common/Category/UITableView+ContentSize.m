//
//  UITableView+ContentSize.m
//  TemplateTest
//
//  Created by HW on 2017/10/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "UITableView+ContentSize.h"

@implementation UITableView (ContentSize)

- (void)setContentSize:(CGSize)contentSize {
    contentSize.height = MAX(contentSize.height, self.height);
    [super setContentSize:contentSize];
}

@end
