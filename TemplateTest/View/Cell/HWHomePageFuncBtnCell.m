//
//  HWHomePageFuncBtnCell.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/13.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWHomePageFuncBtnCell.h"
#import "HWCustomDrawImg.h"
#import <IQUIView+Hierarchy.h>
#import "HWDetectionSelectMemberViewController.h"
@interface HWHomePageFuncBtnCell()

@property(nonatomic,strong)NSMutableArray * btns;

@end

@implementation HWHomePageFuncBtnCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.btns = [NSMutableArray array];
        [self configContentView];
    }
    return self;
}

- (void)configContentView
{
    CGFloat height = 90;
    CGFloat width = kScreenWidth/4;
    NSArray * titles = @[@"我的家庭",@"口腔问答",@"检测",@"记录"];
    for (NSInteger index = 0; index < 4; index++) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(width*index, 0, width, height)];
        btn.contentMode = UIViewContentModeCenter;
        [self.btns addObject:btn];
        [self addSubview:btn];
        btn.backgroundColor = COLOR_F0F0F0;
        UIImage * img = [HWCustomDrawImg drawAutoSizeTextAndImg:[UIImage imageNamed:titles[index]] text:titles[index] grap:5 strconfig:@{NSFontAttributeName:FONT(13),NSForegroundColorAttributeName:COLOR_333333} strContainerSize:CGSizeZero imgPosition:HWCustomDrawTop];
        if ((img.size.width > width) || (img.size.height > height)) {
            img = [HWCustomDrawImg drawCenterInReactImg:img contarinerRect:CGRectMake(0, 0, width, height)];
        }
        [btn setImage:img forState:UIControlStateNormal];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.viewController.navigationController pushViewController:[HWDetectionSelectMemberViewController new] animated:YES];
        }];
    }
}

@end
