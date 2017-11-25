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

@interface DetectionResultViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DetectionResultViewModel *viewModel;
@property (nonatomic, strong) RACSignal *seeDoctorBtnCreateSignal;
@property (nonatomic, strong) RACSignal *notSendBtnCreateSignal;
@property (nonatomic, strong) RACSignal *stateGoodViewCreateSignal;
@property (nonatomic, strong) RACSignal *terribleViewCreateSignal;
@property (nonatomic, strong) UIButton  *seeDoctorBtn;
@property (nonatomic, strong) UIButton  *notSendBtn;
@property (nonatomic, strong) UIButton *lookBtn;// 查看附近医院
@property (nonatomic, strong) UIButton *endBtn;// 完成
@end

@implementation DetectionResultViewController
@dynamic viewModel;

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        [self addSubview:_scrollView];
        _scrollView.alwaysBounceVertical = true;
        _scrollView.showsVerticalScrollIndicator = true;
    }
    return _scrollView;
}

- (UIButton *)lookBtn {
    if (_lookBtn == nil) {
        _lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_lookBtn];
        @weakify(self);
        [_lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView.mas_bottom).with.offset(-kRate(115));
            make.width.mas_equalTo(self.scrollView.width-kRate(30));
        }];
        [_lookBtn setTitle:@"查看附近医生" forState:UIControlStateNormal];
        [_lookBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
        _lookBtn.titleLabel.font =FONT(TF18);
        _lookBtn.titleLabel.textAlignment =NSTextAlignmentCenter;
        _lookBtn.backgroundColor = CD_MainColor;
    }
    return _lookBtn;
}

- (UIButton *)endBtn {
    if (!_endBtn) {
        _endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_endBtn];
        [_endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.lookBtn.mas_bottom).with.offset(kRate(10));
            make.width.equalTo(self.lookBtn);
        }];
        [_endBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_endBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
        _endBtn.titleLabel.font =FONT(TF18);
        _endBtn.titleLabel.textAlignment =NSTextAlignmentCenter;
        _endBtn.backgroundColor = CD_MainColor;
    }
    return _endBtn;
}

- (void)configContentView {
    [super configContentView];
    
    @weakify(self);
    self.seeDoctorBtnCreateSignal = [RACSignal defer:^RACSignal *{
        @strongify(self);
        UIButton *seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        seeBtn.tag = 100;
        [self.scrollView addSubview:seeBtn];
        seeBtn.frame = CGRectMake(kRate(15), 0, self.scrollView.width-kRate(30), kRate(50));
        seeBtn.bottom = self.scrollView.contentSize.height-kRate(81);
        [seeBtn setTitle:@"查看医生" forState:UIControlStateNormal];
        [seeBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
        seeBtn.backgroundColor = CD_MainColor;
        seeBtn.titleLabel.font = FONT(TF16);
        self.seeDoctorBtn = seeBtn;
        return nil;
    }];
    self.notSendBtnCreateSignal = [RACSignal defer:^RACSignal *{
        @strongify(self);
        UIButton *notSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.scrollView addSubview:notSendBtn];
        notSendBtn.frame = CGRectMake(kRate(15), 0, self.scrollView.width-kRate(30), kRate(50));
        notSendBtn.bottom = self.scrollView.contentSize.height-kRate(20);
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
            make.top.mas_equalTo(kRate(171-20));
            make.height.mas_equalTo(kRate(138));
        }];
        return nil;
    }];
    self.terribleViewCreateSignal = [RACSignal defer:^RACSignal *{
        @strongify(self);
        ResultStateTerribleView *terribleView = [ResultStateTerribleView new];
        [self.scrollView addSubview:terribleView];
        terribleView.frame = CGRectMake(0, kRate(80), kScreenWidth, kRate(280));
        terribleView.issueSignal = [RACSignal return:[RACTuple tupleWithObjectsFromArray:self.viewModel.dataArray]];
        CGFloat height = CGRectGetMaxY(terribleView.frame)+kRate(150);
        if (height < self.scrollView.height) {
            height = self.scrollView.height;
        }
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.width, height)];
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
            self.viewModel.seeDoctorSignal = [self.lookBtn rac_signalForControlEvents:UIControlEventTouchUpInside];
            [[self.endBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                [[ViewControllersRouter shareInstance]popToRootViewModelAnimated:true];
            }];
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
        @strongify(self);
        self.viewModel.seeDoctorSignal = [x rac_signalForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [[RACObserve(self, notSendBtn)filter:^BOOL(id value) {
        return value;
    }]subscribeNext:^(UIButton *x) {
        @strongify(self);
        self.viewModel.notSendSignal = [x rac_signalForControlEvents:UIControlEventTouchUpInside];
    }];
    [self.viewModel execute];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backMethod {
    [[ViewControllersRouter shareInstance]popToSpecialViewModelAnimated:true index:1];
}

- (void)dealloc {
    
}

@end
