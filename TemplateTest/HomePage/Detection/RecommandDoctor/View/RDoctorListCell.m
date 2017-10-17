//
//  RDoctorListCell.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "RDoctorListCell.h"
#import "RecommandDoctorModel.h"

@interface RDoctorListCell ()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation RDoctorListCell

- (void)initSubViews {
    self.contentV = [UIView new];
    [self addSubview:self.contentV];
    
    self.headImageView = [UIImageView new];
    [self.contentV addSubview:self.headImageView];
    
    self.describeLabel = [UILabel new];
    [self.contentV addSubview:self.describeLabel];
    self.nameLabel = [UILabel new];
    [self.contentV addSubview:self.nameLabel];
    
    self.arrowImageView = [UIImageView new];
    [self.contentV addSubview:self.arrowImageView];
    
    self.distanceLabel = [UILabel new];
    [self.contentV addSubview:self.distanceLabel];
}

- (void)layoutSubViews {
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRate(14));
        make.right.mas_equalTo(-kRate(14));
        make.top.mas_equalTo(kRate(4));
        make.bottom.mas_equalTo(-4);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentV);
        make.width.height.mas_equalTo(kRate(55));
        make.left.mas_equalTo(kRate(17));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).with.offset(kRate(14));
        make.top.mas_equalTo(kRate(19));
    }];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(kRate(10));
        make.width.mas_equalTo(kRate(200));
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.describeLabel);
        make.size.mas_equalTo(CGSizeMake(kRate(8), kRate(15)));
        make.right.mas_equalTo(-kRate(12));
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView);
        make.centerY.equalTo(self.nameLabel);
    }];
}

- (void)initDefaultConfigs {
    [super initDefaultConfigs];
    self.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    self.contentV.layer.cornerRadius = 3;
    self.contentV.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.contentV.layer.borderWidth = 0.5;
    self.contentV.layer.backgroundColor = COLOR_FFFFFF.CGColor;
    
    self.headImageView.layer.cornerRadius = kRate(30);
    self.headImageView.layer.masksToBounds = true;
    
    self.nameLabel.font = BOLDFONT(TF16);
    self.nameLabel.textColor = CD_Text;
    self.describeLabel.textColor = COLOR_999999;
    self.describeLabel.font = FONT(TF14);
    self.describeLabel.numberOfLines = 2;
    self.distanceLabel.font = FONT(TF12);
    self.distanceLabel.textColor = COLOR_999999;
    
    self.arrowImageView.image = [UIImage imageNamed:@"arrow"];
}

- (void)bindSignal {
    @weakify(self);
    [self.valueSignal subscribeNext:^(RecommandDoctorModel *model) {
        @strongify(self);
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:[UIImage imageNamed:@"selectPeople"]];
        self.describeLabel.text = model.descrip;
        self.nameLabel.text = model.name;
        self.distanceLabel.text = model.distance;
    }];
}

@end
