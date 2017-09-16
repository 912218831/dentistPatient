//
//  DetectionCaptureCell.m
//  TemplateTest
//
//  Created by HW on 17/9/15.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DetectionCaptureCell.h"
#import "DetectionCaptureModel.h"

@interface DetectionCaptureCell ()
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation DetectionCaptureCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
        [self layoutSubViews];
        [self initDefaultConfigs];
    }
    return self;
}

- (void)initSubViews {
    self.photoImageView = [UIImageView new];
    [self addSubview:self.photoImageView];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.deleteBtn];
}

- (void)layoutSubViews {
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.top.mas_equalTo(kRate(6));
        make.right.mas_equalTo(-kRate(5));
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRate(24), kRate(24)));
    }];
}

- (void)initDefaultConfigs {
    self.photoImageView.layer.cornerRadius = 3;
    self.photoImageView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.photoImageView.layer.borderWidth = 0.5;
    self.photoImageView.layer.backgroundColor = COLOR_FFFFFF.CGColor;
    
    self.deleteBtn.layer.cornerRadius = kRate(12);
    self.deleteBtn.layer.backgroundColor = [UIColor redColor].CGColor;
}

- (void)setValueSignal:(RACSignal *)valueSignal {
    _valueSignal = valueSignal;
    [self bindSignal];
}

- (void)bindSignal {
    @weakify(self);
    [self.valueSignal subscribeNext:^(DetectionCaptureModel *model) {
        @strongify(self);
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    }];
}

@end
