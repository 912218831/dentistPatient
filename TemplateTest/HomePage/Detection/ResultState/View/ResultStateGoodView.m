//
//  ResultStateGoodView.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "ResultStateGoodView.h"

@interface ResultStateGoodView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ResultStateGoodView

- (void)initSubViews {
    self.iconImageView = [UIImageView new];
    [self addSubview:self.iconImageView];
    
    self.titleLabel = [UILabel new];
    [self addSubview:self.titleLabel];
}

- (void)layoutSubViews {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRate(120), kRate(77)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.right.bottom.equalTo(self);
    }];
}

- (void)initDefaultConfigs {
    self.iconImageView.image = [UIImage imageNamed:@"detectionResult"];
    
    self.titleLabel.textColor = CD_Text33;
    self.titleLabel.font = FONT(TF15);
    self.titleLabel.text = @"检测完成，状态良好";
}

@end
