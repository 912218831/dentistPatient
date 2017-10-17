//
//  CaseDetailInfoCell.m
//  TemplateTest
//
//  Created by HW on 17/9/13.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "CaseDetailInfoCell.h"
#import "CaseDetailModel.h"

@interface CaseDetailInfoCell ()
@property (nonatomic, strong) UIView *contentV;

@property (nonatomic, strong) UILabel *subjectTitleLabel;
@property (nonatomic, strong) UILabel *captureTitleLabel;
@property (nonatomic, strong) UILabel *doctorTitleLabel;
@property (nonatomic, strong) UILabel *clinicTitleLabel;
@property (nonatomic, strong) UILabel *visitTitleLabel;

@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UILabel *captureLabel;
@property (nonatomic, strong) UILabel *doctorLabel;
@property (nonatomic, strong) UILabel *clinicLabel;
@property (nonatomic, strong) UILabel *visitLabel;
@property (nonatomic, strong) UIButton *uploadImageBtn;
@end

@implementation CaseDetailInfoCell

- (void)initSubViews {
    self.contentV = [UIView new];
    [self addSubview:self.contentV];
    
    self.subjectTitleLabel = [UILabel new];
    [self.contentV addSubview:self.subjectTitleLabel];
    self.captureTitleLabel = [UILabel new];
    [self.contentV addSubview:self.captureTitleLabel];
    self.doctorTitleLabel = [UILabel new];
    [self.contentV addSubview:self.doctorTitleLabel];
    self.clinicTitleLabel = [UILabel new];
    [self.contentV addSubview:self.clinicTitleLabel];
    self.visitTitleLabel = [UILabel new];
    [self.contentV addSubview:self.visitTitleLabel];
    
    self.subjectLabel = [UILabel new];
    [self.contentV addSubview:self.subjectLabel];
    self.captureLabel = [UILabel new];
    [self.contentV addSubview:self.captureLabel];
    self.doctorLabel = [UILabel new];
    [self.contentV addSubview:self.doctorLabel];
    self.clinicLabel = [UILabel new];
    [self.contentV addSubview:self.clinicLabel];
    self.visitLabel = [UILabel new];
    [self.contentV addSubview:self.visitLabel];
    self.uploadImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentV addSubview:self.uploadImageBtn];
}

- (void)layoutSubViews {
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRate(15));
        make.right.mas_equalTo(-kRate(15));
        make.top.mas_equalTo(kRate(10));
        make.bottom.mas_equalTo(kRate(-1));
    }];
    
    NSArray *titleLabels = @[self.subjectTitleLabel, self.captureTitleLabel, self.doctorTitleLabel, self.clinicTitleLabel, self.visitTitleLabel];
    CGFloat y = kRate(18);
    CGFloat h = kRate(18);
    for (int i=0; i<titleLabels.count; i++) {
        UILabel *titleLabel = [titleLabels objectAtIndex:i];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRate(10));
            make.top.mas_equalTo(y);
            make.width.mas_equalTo(kRate(70));
            make.height.mas_equalTo(h);
        }];
        y += h+kRate(14);
    }
    
    y = kRate(18);
    NSArray *labels = @[self.subjectLabel, self.captureLabel, self.doctorLabel, self.clinicLabel, self.visitLabel];
    for (int i=0; i<labels.count; i++) {
        UILabel *label = [labels objectAtIndex:i];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.subjectTitleLabel.mas_right).with.offset(kRate(6));
            make.top.mas_equalTo(y);
            make.height.mas_equalTo(h);
            make.right.mas_equalTo(-kRate(10));
        }];
        y += h+kRate(14);
    }
    
    [self.uploadImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRate(26));
        make.right.mas_equalTo(-kRate(26));
        make.bottom.mas_equalTo(-kRate(17));
        make.height.mas_equalTo(kRate(44));
    }];
}

- (void)initDefaultConfigs {
    self.contentV.layer.cornerRadius = 3;
    self.contentV.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.contentV.layer.borderWidth = 0.5;
    self.contentV.layer.backgroundColor = COLOR_FFFFFF.CGColor;
    
    NSArray *titleLabels = @[self.subjectTitleLabel, self.captureTitleLabel, self.doctorTitleLabel, self.clinicTitleLabel, self.visitTitleLabel];
    for (int i=0; i<titleLabels.count; i++) {
        UILabel *titleLabel = [titleLabels objectAtIndex:i];
        titleLabel.font = FONT(kRate(TF15));
        titleLabel.textColor = CD_Text99;
    }
    NSArray *labels = @[self.subjectLabel, self.captureLabel, self.doctorLabel, self.clinicLabel, self.visitLabel];
    for (int i=0; i<labels.count; i++) {
        UILabel *label = [labels objectAtIndex:i];
        label.font = FONT(TF15);
        label.textColor = CD_Text33;
    }
    
    [self.uploadImageBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    self.uploadImageBtn.titleLabel.font = FONT(TF16);
    self.uploadImageBtn.backgroundColor = CD_MainColor;
    
    self.subjectTitleLabel.text = @"病人名称:";
    self.captureTitleLabel.text = @"拍照时间:";
    self.clinicTitleLabel.text = @"所属诊所:";
    self.doctorTitleLabel.text = @"诊断医生:";
    self.visitTitleLabel.text = @"诊断时间:";
    [self.uploadImageBtn setTitle:@"点击上传病历报告" forState:UIControlStateNormal];
    
    self.subjectLabel.text = @"儿子的牙龈检查";
}

- (void)bindSignal {
    @weakify(self);
    [self.valueSignal subscribeNext:^(CaseDetailModel *model) {
        @strongify(self);
        self.subjectLabel.text = model.patintName;
        self.captureLabel.text = model.time;
        self.doctorLabel.text = model.doctor;
        self.clinicLabel.text = model.clinicName;
        self.visitLabel.text = model.expectedTime;
    }];
    
    self.uploadImageSignal = [self.uploadImageBtn rac_signalForControlEvents:UIControlEventTouchUpInside];
}

@end
