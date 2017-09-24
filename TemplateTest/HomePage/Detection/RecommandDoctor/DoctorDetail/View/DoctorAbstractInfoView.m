//
//  DoctorAbstractInfoView.m
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DoctorAbstractInfoView.h"

@interface DoctorAbstractInfoView ()
@property (nonatomic, strong) UIView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descripLabel;
@property (nonatomic, strong) DoctorAbstractButton *collectBtn;
@end

@implementation DoctorAbstractInfoView

- (void)initSubViews {
    self.iconView = [UIView new];
    self.titleLabel = [UILabel new];
    self.descripLabel = [UILabel new];
    self.collectBtn = [DoctorAbstractButton buttonWithType:UIButtonTypeCustom];

    [self addSubview:self.iconView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.descripLabel];
    [self addSubview:self.collectBtn];
}

- (void)layoutSubViews {
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRate(17));
        make.left.mas_equalTo(kRate(26));
        make.size.mas_equalTo(CGSizeMake(4, kRate(17)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).with.offset(kRate(kRate(8)));
        make.centerY.equalTo(self.iconView);
    }];
    [self.descripLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(kRate(10));
        make.right.mas_equalTo(-kRate(28));
    }];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRate(85));
        make.right.mas_equalTo(-kRate(85));
        make.bottom.mas_equalTo(-kRate(18));
        make.height.mas_equalTo(kRate(32));
    }];
}

- (void)initDefaultConfigs {
    [[RACScheduler mainThreadScheduler]schedule:^{
        self.iconView.layer.cornerRadius = self.iconView.width/2.0;
        self.iconView.layer.backgroundColor = CD_MainColor.CGColor;
    }];
    self.titleLabel.font = FONT(TF16);
    self.titleLabel.textColor = CD_Text33;
    self.descripLabel.textColor = CD_Text99;
    self.descripLabel.font = FONT(TF14);
    self.descripLabel.numberOfLines = 2;
    
    [self.collectBtn setTitle:@"收藏我的医生" forState:UIControlStateNormal];
    [self.collectBtn setTitleColor:CD_MainColor forState:UIControlStateNormal];
    self.collectBtn.layer.borderWidth = 1;
    self.collectBtn.layer.borderColor = CD_MainColor.CGColor;
    self.collectBtn.imageEdgeInsets = UIEdgeInsetsMake(kRate(7), 0, kRate(-6), 0);
    self.collectBtn.titleLabel.font = FONT(TF14);
    self.collectBtn.spaceX = kRate(7);
    self.collectBtn.iconSize = CGSizeMake(kRate(20), kRate(18));
    [self.collectBtn setImage:[UIImage imageNamed:@"collect"]];
    self.collectBtn.hidden = true;
}

- (void)setValueSignal:(RACSignal *)valueSignal {
    @weakify(self);
    [valueSignal subscribeNext:^(RACTuple *x) {
        @strongify(self);
        self.titleLabel.text = [NSString stringWithFormat:@"%@简介",x.first];
        self.descripLabel.text = x.second;
    }];
}

@end


@interface DoctorAbstractButton ()
@property (nonatomic, assign) CGFloat contentW;
@end

@implementation DoctorAbstractButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    DoctorAbstractButton *btn = [super buttonWithType:buttonType];
    if (btn) {
        
    }
    return btn;
}

- (void)setSpaceX:(CGFloat)spaceX {
    _spaceX = spaceX;
    
    [[RACScheduler mainThreadScheduler]schedule:^{
        [self setImage:self.image forState:UIControlStateNormal];
        [self.titleLabel sizeToFit];
        self.contentW = self.iconSize.width + self.spaceX + self.titleLabel.width;
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if (!CGRectEqualToRect(self.imageFrame, CGRectZero)) {
        return self.imageFrame;
    }
    if (self.contentW>0) {
        CGFloat x = (contentRect.size.width - self.contentW)/2.0;
        return CGRectMake(x, (CGRectGetHeight(contentRect)-self.iconSize.height)/2.0, self.iconSize.width, self.iconSize.height);
    }
    return [super imageRectForContentRect:contentRect];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if (!CGRectEqualToRect(self.titleFrame, CGRectZero)) {
        return self.titleFrame;
    }
    if (self.contentW>0) {
        CGFloat x = CGRectGetMaxX([self imageRectForContentRect:contentRect]) + self.spaceX;
        return CGRectMake(x, 0, self.titleLabel.width, contentRect.size.height);
    }
    return [super titleRectForContentRect:contentRect];
}

@end
