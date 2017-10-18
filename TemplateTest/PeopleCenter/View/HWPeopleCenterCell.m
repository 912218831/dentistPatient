//
//  HWPeopleCenterCell.m
//  TemplateTest
//
//  Created by HW on 17/9/10.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWPeopleCenterCell.h"
#import "DashLineView.h"

@interface HWPeopleCenterCell ()
@property (nonatomic, strong, readwrite) UIView *contentV;
@property (nonatomic, strong, readwrite) UILabel *passwordLabel;
@property (nonatomic, strong) UILabel *familyLabel;
@property (nonatomic, strong) DashLineView *lineView;
@property (nonatomic, strong) UIImageView *passwordArrowImg;
@property (nonatomic, strong) UIImageView *familyArrowImg;
@end

@implementation HWPeopleCenterCell

- (void)initSubViews {
    self.contentV = [UIView new];
    [self addSubview:self.contentV];
    
    self.passwordLabel = [UILabel new];
    [self.contentV addSubview:self.passwordLabel];
    
    self.familyLabel = [UILabel new];
    [self.contentV addSubview:self.familyLabel];
    
    self.lineView = [[DashLineView alloc]initWithLineHeight:0 space:0 direction:Horizontal strokeColor:UIColorFromRGB(0xcccccc)];
    [self.contentV addSubview:self.lineView];
    
    self.passwordArrowImg = [UIImageView new];
    [self.contentV addSubview:self.passwordArrowImg];
    
    self.familyArrowImg = [UIImageView new];
    [self.contentV addSubview:self.familyArrowImg];
}

- (void)layoutSubViews {
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kRate(15));
        make.right.equalTo(self).with.offset(-kRate(15));
        make.top.equalTo(self).with.offset(1);
        make.bottom.equalTo(self).with.offset(-1);
    }];
    CGFloat offX = kRate(17);
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentV);
        make.bottom.equalTo(self.mas_centerY);
        make.left.equalTo(self.contentV).with.offset(offX);
    }];
    [self.familyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentV);
        make.top.equalTo(self.mas_centerY);
        make.bottom.equalTo(self);
        make.left.equalTo(self.contentV).with.offset(offX);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentV);
        make.height.mas_equalTo(0.6);
        make.top.equalTo(self.passwordLabel.mas_bottom).with.offset(-0.2);
    }];
    [self.passwordArrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentV).with.offset(-offX);
        make.width.mas_equalTo(kRate(8));
        make.height.mas_equalTo(kRate(15));
        make.centerY.equalTo(self.passwordLabel);
    }];
    [self.familyArrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentV).with.offset(-offX);
        make.width.mas_equalTo(kRate(8));
        make.height.mas_equalTo(kRate(15));
        make.centerY.equalTo(self.familyLabel);
    }];
}

- (void)initDefaultConfigs {
    self.contentV.layer.cornerRadius = 3;
    self.contentV.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.contentV.layer.borderWidth = 0.6;
    self.contentV.layer.backgroundColor = COLOR_FFFFFF.CGColor;
    
    self.passwordLabel.font = FONT(TF16);
    self.passwordLabel.textColor = CD_Text;
    self.passwordLabel.text = @"设置密码";
    self.passwordLabel.userInteractionEnabled = true;
    
    self.familyLabel.font = FONT(TF16);
    self.familyLabel.textColor = CD_Text;
    self.familyLabel.text = @"我的家庭";
    self.familyLabel.userInteractionEnabled = true;
    
    self.passwordArrowImg.image = [UIImage imageNamed:@"arrow"];
    self.familyArrowImg.image = [UIImage imageNamed:@"arrow"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    UIView *eventView = touch.view;
    if (eventView == self.passwordLabel) {
        if (self.touchEvent) {
            self.touchEvent(ChangePW);
        }
    } else if (eventView == self.familyLabel) {
        if (self.touchEvent) {
            self.touchEvent(Family);
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    NSLog(@"view=%@",view);
    return view;
}


@end

