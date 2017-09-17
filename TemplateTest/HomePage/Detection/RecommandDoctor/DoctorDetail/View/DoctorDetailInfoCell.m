//
//  DoctorDetailInfoCell.m
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DoctorDetailInfoCell.h"
#import "DashLineView.h"
#import "DoctorAbstractInfoView.h"
#import "DoctorDetailAttachedView.h"
@interface DoctorDetailInfoCell ()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *hospitalLabel;
@property (nonatomic, strong) UILabel *orderedLabel;
@property (nonatomic, strong) DoctorDetailAttachedView *leftView;
@property (nonatomic, strong) DoctorDetailAttachedView *rightView;
@property (nonatomic, strong) DoctorAbstractInfoView *doctorAbstractView;
@property (nonatomic, strong) DashLineView *centerLineView;
@property (nonatomic, strong) DashLineView *horizonLineView;
@end

@implementation DoctorDetailInfoCell

- (void)initSubViews {
    self.contentV = [UIView new];
    [self addSubview:self.contentV];
    
    self.headImageView = [UIImageView new];
    [self.contentV addSubview:self.headImageView];
    
    self.nameLabel = [UILabel new];
    [self.contentV addSubview:self.nameLabel];
    self.hospitalLabel = [UILabel new];
    [self.contentV addSubview:self.hospitalLabel];
    self.orderedLabel = [UILabel new];
    [self.contentV addSubview:self.orderedLabel];
    
    self.leftView = [DoctorDetailAttachedView new];
    [self.contentV addSubview:self.leftView];
    self.rightView = [DoctorDetailAttachedView new];
    [self.contentV addSubview:self.rightView];
    
    self.doctorAbstractView = [DoctorAbstractInfoView new];
    [self.contentV addSubview:self.doctorAbstractView];
    
    self.horizonLineView = [[DashLineView alloc]initWithLineHeight:2 space:1 direction:Horizontal strokeColor:COLOR_CCCCCC];
    [self.contentV addSubview:self.horizonLineView];
    self.centerLineView = [[DashLineView alloc]initWithLineHeight:0 space:0 direction:Vertical strokeColor:COLOR_CCCCCC];
    [self.contentV addSubview:self.centerLineView];
}

- (void)layoutSubViews {
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRate(14));
        make.right.mas_equalTo(-kRate(14));
        make.top.mas_equalTo(kRate(10));
        make.bottom.mas_equalTo(kRate(7));
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRate(21));
        make.width.height.mas_equalTo(kRate(55));
        make.left.mas_equalTo(kRate(19));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).with.offset(kRate(10));
        make.top.equalTo(self.headImageView);
    }];
    [self.hospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(kRate(8));
    }];
    [self.orderedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.hospitalLabel.mas_bottom).with.offset(kRate(8));
    }];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentV);
        make.top.equalTo(self.orderedLabel.mas_bottom).with.offset(kRate(15));
        make.height.mas_equalTo(kRate(52));
        make.right.equalTo(self.mas_centerX);
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentV);
        make.top.equalTo(self.leftView);
        make.bottom.equalTo(self.leftView);
        make.left.equalTo(self.leftView.mas_right);
    }];
    [self.doctorAbstractView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentV);
        make.right.equalTo(self.contentV);
        make.top.equalTo(self.leftView.mas_bottom).with.offset(kRate(17));
    }];
    [self.horizonLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRate(14));
        make.bottom.equalTo(self.doctorAbstractView.mas_top);
        make.right.mas_equalTo(-kRate(14));
        make.height.mas_equalTo(1);
    }];
    [self.centerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftView);
        make.centerX.equalTo(self.contentV);
        make.size.mas_equalTo(CGSizeMake(1, kRate(45)));
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
    self.hospitalLabel.textColor = COLOR_999999;
    self.hospitalLabel.font = FONT(TF14);
    self.orderedLabel.font = FONT(TF14);
    self.orderedLabel.textColor = COLOR_999999;
    
    self.leftView.direction = Left;
    self.rightView.direction = Right;
    
    self.nameLabel.text = @"吴医生";
    self.hospitalLabel.text = @"北京口腔医院";
    self.orderedLabel.text = @"34人预约过";
    self.headImageView.backgroundColor = [UIColor redColor];
    self.leftView.valueSignal = [RACSignal return:RACTuplePack(@"¥268",@"已有1234人预约成功")];
    self.rightView.valueSignal = [RACSignal return:RACTuplePack(@"80",@"已有1234人预约成功")];
}

- (void)bindSignal {
    @weakify(self);
    [self.valueSignal subscribeNext:^(id model) {
        @strongify(self);
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img.taopic.com/uploads/allimg/140322/235058-1403220K93993.jpg"]];
    }];
}

@end
