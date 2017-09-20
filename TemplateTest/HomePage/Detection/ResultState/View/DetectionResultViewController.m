//
//  DetectionResultViewController.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DetectionResultViewController.h"
#import "ResultStateGoodView.h"
#import "DetectionResultViewModel.h"
#import "ResultStateTerribleView.h"
#import "RecommandDoctorViewModel.h"

@interface DetectionResultViewController ()
@property (nonatomic, strong) DetectionResultViewModel *viewModel;
@property (nonatomic, strong) RACSignal *seeDoctorBtnCreateSignal;
@property (nonatomic, strong) RACSignal *notSendBtnCreateSignal;
@property (nonatomic, strong) RACSignal *stateGoodViewCreateSignal;
@property (nonatomic, strong) RACSignal *terribleViewCreateSignal;
@property (nonatomic, strong) UIButton  *seeDoctorBtn;
@property (nonatomic, strong) UIButton  *notSendBtn;
@end

@implementation DetectionResultViewController
@dynamic viewModel;

- (void)configContentView {
    [super configContentView];
    
    @weakify(self);
    self.seeDoctorBtnCreateSignal = [RACSignal defer:^RACSignal *{
        @strongify(self);
        UIButton *seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        seeBtn.tag = 100;
        [self addSubview:seeBtn];
        [seeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRate(15));
            make.bottom.mas_equalTo(-kRate(81));
            make.height.mas_equalTo(kRate(50));
            make.right.mas_equalTo(-kRate(15));
        }];
        [seeBtn setTitle:@"查看诊所" forState:UIControlStateNormal];
        [seeBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
        seeBtn.backgroundColor = CD_MainColor;
        seeBtn.titleLabel.font = FONT(TF16);
        self.seeDoctorBtn = seeBtn;
        return nil;
    }];
    self.notSendBtnCreateSignal = [RACSignal defer:^RACSignal *{
        @strongify(self);
        UIButton *notSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:notSendBtn];
        [notSendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRate(15));
            make.bottom.mas_equalTo(-kRate(20));
            make.height.mas_equalTo(kRate(50));
            make.right.mas_equalTo(-kRate(15));
        }];
        [notSendBtn setTitle:@"暂不发送给医生" forState:UIControlStateNormal];
        [notSendBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
        notSendBtn.backgroundColor = UIColorFromRGB(0xb4c8da);
        notSendBtn.titleLabel.font = FONT(TF16);
        self.notSendBtn = notSendBtn;
        return nil;
    }];
    self.stateGoodViewCreateSignal = [RACSignal defer:^RACSignal *{
        @strongify(self);
        ResultStateGoodView *stateGoodView = [ResultStateGoodView new];
        [self addSubview:stateGoodView];
        [stateGoodView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.mas_equalTo(kRate(171));
            make.height.mas_equalTo(kRate(138));
        }];
        return nil;
    }];
    self.terribleViewCreateSignal = [RACSignal defer:^RACSignal *{
        @strongify(self);
        ResultStateTerribleView *terribleView = [ResultStateTerribleView new];
        [self addSubview:terribleView];
        [terribleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.mas_equalTo(kRate(80));
            make.height.mas_greaterThanOrEqualTo(kRate(280));
        }];
        terribleView.issueSignal = [RACSignal return:[RACTuple tupleWithObjectsFromArray:self.viewModel.dataArray]];
        return nil;
    }];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    [self.viewModel bindViewWithSignal];
    
    [Utility showMBProgress:self.contentView message:nil];
    @weakify(self);
    [self.viewModel.requestSignal.newSwitchToLatest subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.boolValue) {
            [self.stateGoodViewCreateSignal subscribe:[RACSubject subject]];
        } else {
            [self.terribleViewCreateSignal subscribe:[RACSubject subject]];
            [self.seeDoctorBtnCreateSignal subscribe:[RACSubject subject]];
            [self.notSendBtnCreateSignal   subscribe:[RACSubject subject]];
        }
        [Utility hideMBProgress:self.contentView];
    } error:^(NSError *error) {
        @strongify(self);
        [Utility showToastWithMessage:error.domain];
        [Utility hideMBProgress:self.contentView];
    } completed:^{
        @strongify(self);
        [Utility hideMBProgress:self.contentView];
    }];
    
    [[RACObserve(self, seeDoctorBtn)filter:^BOOL(id value) {
        return value;
    }]subscribeNext:^(UIButton *x) {
        [[x rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            RecommandDoctorViewModel *vm = [RecommandDoctorViewModel new];
            [[ViewControllersRouter shareInstance]pushViewModel:vm animated:true];
        }];
    }];
    
    
    [self.viewModel execute];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

@end
