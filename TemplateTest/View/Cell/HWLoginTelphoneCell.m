//
//  HWLoginTelphoneCell.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/7.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWLoginTelphoneCell.h"
@interface HWLoginTelphoneCell()
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;
@end

@implementation HWLoginTelphoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self bindModel];
}

- (void)bindModel
{
    self.viewModel = [[HWLoginCellViewModel alloc] init];
    RAC(self.telphoneTF, text) = [self.telphoneTF.rac_textSignal map:^id(NSString *value) {
        if (value.length>11) {
            return [value substringToIndex:11];
        } else {
            return value;
        }
    }];
    RAC(self.viewModel,telphone) = [self.telphoneTF.rac_textSignal skip:1];
    RAC(self.verifyCodeTF, text) = [self.verifyCodeTF.rac_textSignal map:^id(NSString *value) {
        if (value.length>8) {
            return [value substringToIndex:8];
        } else {
            return value;
        }
    }];
    RAC(self.viewModel,verifyCode) = [self.verifyCodeTF.rac_textSignal skip:1];
    @weakify(self);
    [RACObserve(self.viewModel, title) subscribeNext:^(id x) {
        @strongify(self);
    
        dispatch_async(dispatch_get_main_queue(), ^{
            self.verifyCodeBtn.titleLabel.text = x;
            [self.verifyCodeBtn setTitle:x forState:UIControlStateNormal];
        });

    }];
    [[self.verifyCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton * btn) {
        if (![Utility validateMobile:self.viewModel.telphone]) {
            [Utility showToastWithMessage:@"请输入正确的手机号"];
        }else
        {
            [self.viewModel.verifyCodeCommand execute:nil];
        }
        
    }];
    [self.viewModel.verifyCodeCommand.executionSignals.switchToLatest subscribeNext:^(NSString * x) {
        [Utility showToastWithMessage:x];
    }];
    [self.viewModel.verifyCodeCommand.errors subscribeNext:^(NSError *x) {
        [Utility showToastWithMessage:x.localizedDescription];
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
