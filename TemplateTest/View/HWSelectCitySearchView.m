//
//  HWSelectCitySearchView.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/26.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWSelectCitySearchView.h"
@interface HWSelectCitySearchView()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation HWSelectCitySearchView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.layer.borderColor = COLOR_999999.CGColor;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.cornerRadius = 3.0f;
    self.contentView.layer.masksToBounds = YES;
}
@end
