//
//  HWPeopleCenterHeadView.m
//  TemplateTest
//
//  Created by HW on 17/9/10.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWPeopleCenterHeadView.h"

@interface HWPeopleCenterHeadView ()

@end

@implementation HWPeopleCenterHeadView

- (void)initSubViews {
    self.backImageView = [UIImageView new];
    [self addSubview:self.backImageView];
    
    self.headerImageView = [UIImageView new];
    [self addSubview:self.headerImageView];
    
    self.nameLabel = [UILabel new];
    [self addSubview:self.nameLabel];
    
    self.phoneLabel = [UILabel new];
    [self addSubview:self.phoneLabel];
    
    self.scoreBtn = [DoctorAbstractButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.scoreBtn];
}

- (void)layoutSubViews {
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self).with.offset(kRate(39));
    }];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(kRate(156/2.0));
        make.left.mas_equalTo(kRate(17));
        make.width.height.mas_equalTo(kRate(90));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_centerY).with.offset(-20);
        make.left.equalTo(self.headerImageView.mas_right).with.offset(kRate(7));
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_centerY).with.offset(kRate(6));
        make.left.equalTo(self.nameLabel);
    }];
    [self.scoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-kRate(17));
        make.centerY.equalTo(self.headerImageView);
        make.height.mas_equalTo(kRate(36));
    }];
}

- (void)initDefaultConfigs {
    self.headerImageView.layer.borderWidth = 4;
    self.headerImageView.layer.borderColor = UIColorFromRGB(0xf3f3f5).CGColor;
    self.headerImageView.layer.cornerRadius = kRate(45);
    self.headerImageView.layer.masksToBounds = true;
    
    self.nameLabel.font = BOLDFONT(TF16);
    self.nameLabel.textColor = CD_Text;
    
    self.phoneLabel.font = FONT(TF16);
    self.phoneLabel.textColor = CD_Text33;
    
    self.nameLabel.text = @"";
    self.phoneLabel.text = @"";
    
    self.backImageView.image = [UIImage imageNamed:@"personalCenter"];
    
    self.scoreBtn.layer.cornerRadius = kRate(18);
    [self.scoreBtn setBackgroundColor:[UIColor whiteColor]];
    [self.scoreBtn setTitle:@"积分" forState:UIControlStateNormal];
    self.scoreBtn.titleLabel.font = FONT(TF14);
    [self.scoreBtn setTitleColor:CD_Text forState:UIControlStateNormal];
    self.scoreBtn.spaceX = kRate(5);
    self.scoreBtn.iconSize = CGSizeMake(kRate(20), kRate(18));
    [self.scoreBtn setImage:[UIImage imageNamed:@"积分"]];
}

@end
