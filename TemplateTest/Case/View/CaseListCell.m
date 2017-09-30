//
//  CaseListCell.m
//  TemplateTest
//
//  Created by HW on 17/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "CaseListCell.h"
#import "CaseItemModel.h"

@interface CaseListCell ()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UILabel *actionLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImageView *stateImageView;
@end

@implementation CaseListCell

- (void)initSubViews {
    self.contentV = [UIView new];
    [self addSubview:self.contentV];
    
    self.headImageView = [UIImageView new];
    [self addSubview:self.headImageView];
    
    self.describeLabel = [UILabel new];
    [self.contentV addSubview:self.describeLabel];
    self.actionLabel = [UILabel new];
    [self.contentV addSubview:self.actionLabel];
    self.dateLabel = [UILabel new];
    [self.contentV addSubview:self.dateLabel];

    self.arrowImageView = [UIImageView new];
    [self.contentV addSubview:self.arrowImageView];
    self.stateImageView = [UIImageView new];
    [self.contentV addSubview:self.stateImageView];
}

- (void)layoutSubViews {
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRate(40));
        make.right.mas_equalTo(-kRate(14));
        make.top.mas_equalTo(kRate(10));
        make.bottom.mas_equalTo(-1);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentV.mas_left);
        make.centerY.equalTo(self.contentV);
        make.width.height.mas_equalTo(kRate(60));
    }];
    CGFloat offX = kRate(43);
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offX);
        make.top.mas_equalTo(kRate(20));
    }];
    [self.actionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offX);
        make.top.equalTo(self.describeLabel.mas_bottom).with.offset(kRate(6));
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offX);
        make.top.equalTo(self.actionLabel.mas_bottom).with.offset(kRate(6));
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentV);
        make.size.mas_equalTo(CGSizeMake(kRate(8), kRate(15)));
        make.right.mas_equalTo(-kRate(35));
    }];
    [self.stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentV).with.offset(kRate(-46));
        make.right.equalTo(self.contentV).with.offset(kRate(46));
        make.size.mas_equalTo(CGSizeMake(kRate(92), kRate(92)));
    }];
}

- (void)initDefaultConfigs {
    [super initDefaultConfigs];
    self.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    self.contentV.layer.cornerRadius = 3;
    self.contentV.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.contentV.layer.borderWidth = 0.5;
    self.contentV.layer.masksToBounds = true;
    self.contentV.layer.backgroundColor = COLOR_FFFFFF.CGColor;
    
    self.headImageView.layer.borderWidth = 4;
    self.headImageView.layer.borderColor = COLOR_FFFFFF.CGColor;
    self.headImageView.layer.cornerRadius = kRate(30);
    self.headImageView.layer.masksToBounds = true;
    self.headImageView.layer.backgroundColor = [UIColor redColor].CGColor;
    
    self.describeLabel.font = BOLDFONT(TF16);
    self.describeLabel.textColor = CD_Text;
    self.actionLabel.textColor = COLOR_999999;
    self.actionLabel.font = FONT(TF14);
    self.dateLabel.textColor = COLOR_999999;
    self.dateLabel.font =FONT(TF13);
    
    self.arrowImageView.image = [UIImage imageNamed:@"arrow"];
}

- (void)bindSignal {
    @weakify(self);
    [self.valueSignal subscribeNext:^(CaseItemModel *model) {
        @strongify(self);
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
        self.describeLabel.text = @"儿子的牙龈癍检查";
        self.actionLabel.text = @"已发送给空腔诊所的 吴医生";
        self.dateLabel.text = model.time;
        if (model.state) {
            self.stateImageView.image = [UIImage imageNamed:@"完成"];
        } else {
            self.stateImageView.image = [UIImage imageNamed:@"进行中"];
        }
    }];
}

@end
