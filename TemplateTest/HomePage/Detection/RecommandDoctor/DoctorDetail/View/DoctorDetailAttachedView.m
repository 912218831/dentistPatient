//
//  DoctorDetailAttachedView.m
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DoctorDetailAttachedView.h"

@interface DoctorDetailAttachedView ()
@property (nonatomic, strong) MoreSubView *moreSubView;
@property (nonatomic, strong) UILabel *noteLabel;
@end

@implementation DoctorDetailAttachedView

- (void)setDirection:(AttachedViewDirection)direction {
    _direction = direction;
    if (direction == Left) {
        self.noteLabel.textColor = CD_Text99;
        self.moreSubView.needShowIcon = false;
        self.moreSubView.titleLabel.text = @"人均:";
        self.moreSubView.titleLabel.textColor = CD_MainColor;
        self.moreSubView.detailLabel.textColor = CD_MainColor;
    } else {
        self.noteLabel.textColor = UIColorFromRGB(0xff6a28);
        self.moreSubView.needShowIcon = true;
        self.moreSubView.titleLabel.text = @"优惠券:";
        self.moreSubView.titleLabel.textColor = UIColorFromRGB(0xff6a28);
        self.moreSubView.detailLabel.textColor = UIColorFromRGB(0xff6a28);
    }
}

- (void)initSubViews {
    
    self.moreSubView = [MoreSubView new];
    [self addSubview:self.moreSubView];
    
    self.noteLabel = [UILabel new];
    [self addSubview:self.noteLabel];
}

- (void)layoutSubViews {
    [self.moreSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kRate(28));
    }];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)initDefaultConfigs {
    self.noteLabel.font = FONT(TF12);
    self.noteLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)setValueSignal:(RACSignal *)valueSignal {
    @weakify(self);
    [valueSignal subscribeNext:^(RACTuple *t) {
        @strongify(self);
        self.moreSubView.detailLabel.text = t.first;
        self.noteLabel.text = t.second;
        [self.moreSubView reloadData];
    }];
}

@end


@interface MoreSubView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation MoreSubView

- (void)initSubViews {
    
    self.iconImageView = [UIImageView new];
    [self addSubview:self.iconImageView];
    
    self.titleLabel = [UILabel new];
    [self addSubview:self.titleLabel];
    
    self.detailLabel = [UILabel new];
    [self addSubview:self.detailLabel];
    
}

- (void)layoutSubViews {
    
}

- (void)initDefaultConfigs {
    self.iconImageView.image = [UIImage imageNamed:@"discounts"];
    self.titleLabel.font = FONT(TF12);
    self.detailLabel.font = FONT(TF30);
}

- (void)reloadData {
    @weakify(self);
    [[RACScheduler mainThreadScheduler]schedule:^{
        @strongify(self);
        [self.titleLabel sizeToFit];
        [self.detailLabel sizeToFit];
        CGFloat w = self.titleLabel.width + self.detailLabel.width;
        if (self.needShowIcon) {
            w += kRate(13) + kRate(6) + kRate(4);
        }
        CGFloat x = (self.width - w)/2.0;
        if (self.needShowIcon) {
            [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(x);
                make.centerY.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kRate(13), kRate(15)));
            }];
            x += kRate(13) + kRate(6);
        }
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(x);
            make.centerY.equalTo(self);
        }];
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).with.offset(kRate(4));
            make.centerY.equalTo(self);
        }];
    }];
}

@end
