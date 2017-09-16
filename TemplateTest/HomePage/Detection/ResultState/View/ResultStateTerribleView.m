//
//  ResultStateTerribleView.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "ResultStateTerribleView.h"
#import "DetectionIssueItemModel.h"

@interface ResultStateTerribleView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *recommandNoteLabel;
@end

@implementation ResultStateTerribleView

- (void)initSubViews {
    self.iconImageView = [UIImageView new];
    [self addSubview:self.iconImageView];
    
    self.titleLabel = [UILabel new];
    [self addSubview:self.titleLabel];
    
    self.recommandNoteLabel = [UILabel new];
    [self addSubview:self.recommandNoteLabel];
}

- (void)layoutSubViews {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRate(120), kRate(75)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(kRate(44));
    }];
    [self.recommandNoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
    }];
}

- (void)initDefaultConfigs {
    self.iconImageView.backgroundColor = [UIColor redColor];
    
    self.titleLabel.font = FONT(TF15);
    self.titleLabel.textColor = CD_Text33;
    self.titleLabel.text = @"检测完成，但发现了些问题";
    
    self.recommandNoteLabel.font = FONT(TF16);
    self.recommandNoteLabel.textColor = CD_MainColor;
    self.recommandNoteLabel.text = @"系统给你推荐了5个地方的医生";
}

- (void)setIssueSignal:(RACSignal *)issueSignal {
    @weakify(self);
    [issueSignal subscribeNext:^(RACTuple *x) {
        @strongify(self);
        __block CGFloat offY = kRate(163);
        [x.allObjects.rac_sequence foldLeftWithStart:@0 reduce:^id(NSNumber* accumulator, DetectionIssueItemModel *issue) {
            UILabel *label = [UILabel new];
            [self addSubview:label];
            label.font = FONT(TF13);
            label.textColor = CD_Text99;
            label.text = [NSString stringWithFormat:@"%@.%@",accumulator,issue.title];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(offY);
                make.centerX.equalTo(self);
            }];
            offY += kRate(20);
            return @(accumulator.integerValue+1);
        }];
        if (x.allObjects.count > 4) {
            [self.recommandNoteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.bottom.equalTo(self);
                make.top.mas_equalTo(offY+kRate(30));
            }];
        }
    }];
}

@end
