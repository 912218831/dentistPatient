//
//  HWHomePageSecondHeader.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/13.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWHomePageSecondHeader.h"

@interface HWHomePageSecondHeader()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@end

@implementation HWHomePageSecondHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title
{
    self.titleLab.text = title;
}

@end
