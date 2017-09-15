//
//  CaseSegmentButton.m
//  TemplateTest
//
//  Created by HW on 17/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "CaseSegmentButton.h"

@interface CaseSegmentButton ()<HWBaseViewProtocol>
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation CaseSegmentButton

- (instancetype)init {
    if (self = [super init]) {
        [self initSubViews];
        [self layoutSubViews];
        [self initDefaultConfigs];
    }
    return self;
}

- (void)initSubViews {
    self.titleLabel = [UILabel new];
    [self addSubview:self.titleLabel];
    
    self.iconImageView = [UIImageView new];
    [self addSubview:self.iconImageView];
}

- (void)layoutSubViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self);
    }];
}

- (void)initDefaultConfigs {
    self.titleLabel.font = FONT(TF16);
    self.titleLabel.textColor = COLOR_FFFFFF;
    self.iconImageView.image = [UIImage imageNamed:@"arrow_down"];
    
}

@end
