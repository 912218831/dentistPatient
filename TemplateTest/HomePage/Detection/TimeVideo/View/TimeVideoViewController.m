//
//  TimeVideoViewController.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "TimeVideoViewController.h"
#import "HKDisplayView.h"
#import "HWCustomDrawImg.h"
#import "TimeVideoViewModel.h"
#import "WifiListView.h"
#import "WifiInfoModel.h"
@interface TimeVideoViewController ()<WifiListViewDelegate,HKDisplayViewDelegate>
{
    enum {ConnectingTypeNone,
        ConnectingTypeVideoWait105,
        ConnectingTypeVideoWait106,
        ConnectingTypeListenAudioWait105,
        ConnectingTypeListenAudioWait106,
        ConnectingTypeSpeakerAudioWait105,
        ConnectingTypeSpeakerAudioWait106,
        ConnectingTypeRegistServerSuccess,      //注册监控服务成功
        ConnectingTypeRegistServerFail,         //注册监控服务失败
        ConnectingTypeLoginSuccess,             //登陆成功
        ConnectingTypeLoginFail,                //登陆失败
    } _connectingType;

}
//@property(strong,nonatomic)HKDisplayView * displayView;
@property(strong,nonatomic)UIButton * captureBtn;
@property(strong,nonatomic)TimeVideoViewModel * viewModel;
@property(strong,nonatomic)WifiListView * listView;
@property(strong,nonatomic)UIButton * resetBtn;//回复AP
@property(strong,nonatomic)UIButton * openLightBtn;//开启蓝光
@end

@implementation TimeVideoViewController
@dynamic viewModel;
- (void)viewDidLoad
{
    [super viewDidLoad];    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.viewModel.refreshCommand execute:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.viewModel.quitVideo execute:nil];

}
- (void)configContentView
{
    [super configContentView];
//    UIImage * rightItemImg = [HWCustomDrawImg drawTextImg:CGSizeMake(50, 20) backgroundColor:[UIColor clearColor] content:@"刷新" contentConfig:@{NSFontAttributeName:FONT(15.0f),NSForegroundColorAttributeName:COLOR_FFFFFF}];
//    self.navigationItem.rightBarButtonItem = [Utility navButton:self action:@selector(rightAction) image:rightItemImg];
    self.viewModel.displayView.frame = CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT);
        [self.view addSubview:self.viewModel.displayView];
    self.viewModel.displayView.delegate = self;
    self.captureBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - 100)/2, CONTENT_HEIGHT - 100 - kRate(70), 100, 100)];
    [self.captureBtn setImage:ImgWithName(@"photograph") forState:UIControlStateNormal];
    [self.view addSubview:self.captureBtn];
//    self.resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CONTENT_HEIGHT - 100 - kRate(70), 100, 20)];
//    [self.resetBtn setTitle:@"重置为AP模式" forState:UIControlStateNormal];
//    [self.view addSubview:self.resetBtn];
//    self.openLightBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - 100-20), CONTENT_HEIGHT - 100 - kRate(70), 100, 20)];
//    [self.openLightBtn setTitle:@"开启灯光" forState:UIControlStateNormal];
//    [self.view addSubview:self.openLightBtn];

    self.listView = [[[NSBundle mainBundle] loadNibNamed:@"WifiListView" owner:self options:nil] firstObject];
    self.listView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 300);
    [self.view addSubview:self.listView];
    self.listView.delegate = self;

}

- (void)bindViewModel
{
    [super bindViewModel];
    @weakify(self);
    self.captureBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.viewModel.displayView snapCurrentVideo];
        return [RACSignal empty];
    }];
    [self.viewModel.listDataChannel.leadingTerminal subscribeNext:^(id x) {
        [UIView animateWithDuration:0.25 animations:^{
            self.listView.top = kScreenHeight - 300;
        }];
        if ([x isKindOfClass:[NSArray class]]) {
            //wifi列表
            self.listView.dataArr = [x copy];
        }
        else
        {
            self.listView.lanDeviceDic = x;
        }
    }];
    self.listView.refreshBtn.rac_command = self.viewModel.refreshCommand;
    self.listView.selectDeviceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.viewModel.selectDeviceCommand execute:input];
        return [RACSignal empty];
    }];
    self.listView.selectWifiCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.viewModel.setLanCommand execute:input];
        return [RACSignal empty];
    }];
    self.viewModel.startVideoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [UIView animateWithDuration:0.25 animations:^{
            self.listView.top = kScreenHeight;
        }];
        return [RACSignal empty];
    }];
    self.resetBtn.rac_command = self.viewModel.resetCommand;
    self.openLightBtn.rac_command = self.viewModel.openLightCommand;
    [[RACObserve(self.viewModel, captureImage) skip:1]subscribeNext:^(UIImage * x) {
//        self.viewModel.takePhoto(x);
        @strongify(self);
        [self backMethod];
    }];
}

- (void)rightAction
{
    [self.viewModel.refreshCommand execute:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backMethod {
    [super backMethod];
//    UIImage * img = [UIImage imageWithData:UIImagePNGRepresentation(self.viewModel.captureImage)];
//    self.viewModel.takePhoto(img);
    [self.viewModel.quitVideo execute:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)snapShotFailed:(NSError *)error
{
    [Utility hideMBProgress:self.view];
    [Utility showToastWithMessage:error.localizedDescription];
}

- (void)snapShotSuccess:(UIImage *)captureImg
{
    [Utility hideMBProgress:self.view];
    [Utility showToastWithMessage:@"抓拍成功"];
//    UIImage * img = [UIImage imageWithData:UIImagePNGRepresentation(captureImg)];
        self.viewModel.takePhoto([UIImage imageWithData:UIImagePNGRepresentation(captureImg)]);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ViewControllersRouter shareInstance] popViewModelAnimated:YES];
    });
}

- (void)snapStart
{
    [Utility showMBProgress:self.view message:@"抓怕中..."];
}

- (void)dealloc
{
    
}

@end
