//
//  HWMarginLabel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/10/11.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWMarginLabel.h"

@implementation HWMarginLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (CGSize)intrinsicContentSize
{
   CGSize size = [super intrinsicContentSize];
    size.width +=20;
    size.height +=20;
    return size;
}

@end
