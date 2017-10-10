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
@interface TimeVideoViewController ()<WifiListViewDelegate>
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

- (void)configContentView
{
    [super configContentView];
    UIImage * rightItemImg = [HWCustomDrawImg drawTextImg:CGSizeMake(50, 20) backgroundColor:[UIColor clearColor] content:@"刷新" contentConfig:@{NSFontAttributeName:FONT(15.0f),NSForegroundColorAttributeName:COLOR_FFFFFF}];
    self.navigationItem.rightBarButtonItem = [Utility navButton:self action:@selector(rightAction) image:rightItemImg];
    self.viewModel.displayView.frame = CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT);
        [self.view addSubview:self.viewModel.displayView];
    
    self.captureBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - 100)/2, CONTENT_HEIGHT - 100 - kRate(70), 100, 100)];
    [self.captureBtn setImage:ImgWithName(@"photograph") forState:UIControlStateNormal];
    [self.view addSubview:self.captureBtn];
    
    self.listView = [[[NSBundle mainBundle] loadNibNamed:@"WifiListView" owner:self options:nil] firstObject];
    self.listView.frame = CGRectMake(0, kScreenHeight - 300, kScreenWidth, 300);
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
        
        self.listView.lanDeviceDic = x;
    }];
    self.listView.refreshBtn.rac_command = self.viewModel.refreshCommand;
}

- (void)rightAction
{
//    [self stopVideo];
//    self.decodeSDK = [[HKDecodeSDK alloc] initWithDelegate:self];
//    hk_InitLAN((__bridge void *)(self), &HKLanDataCallback);
//    //刷新局域网设备，当程序进入后台时，请调用hk_LanRefresh_EX(2);
//    hk_LanRefresh_EX(1);
//    NSLog(@"刷新");
    [self.viewModel.refreshCommand execute:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cellDidselect:(id)wifiInfo
{
    if ([wifiInfo isKindOfClass:[WifiInfoModel class]]) {
        //wifi列表

    }
    else
    {
        //设备列表
        [self.viewModel.playVideoCommand execute:wifiInfo];
    }
}

- (void)dealloc
{
    
- (void)backMethod {
    [super backMethod];
    self.viewModel.takePhoto([UIImage imageNamed:@"beautiful.jpg"]);
}

@end
