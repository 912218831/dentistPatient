//
//  SettingDeviceViewModel.m
//  TemplateTest
//
//  Created by HW on 2017/11/4.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "SettingDeviceViewModel.h"

@implementation SettingDeviceViewModel

- (instancetype)init {
    if (self = [super init]) {
        NSArray *titles = @[@"1.请在WIIF列表中找到设备",@"2.请选择设备",@"3.为设备设置当前网络的账号和密码"];
        self.titleModels = [NSMutableArray arrayWithCapacity:titles.count];
        for (int i=0; i<titles.count; i++) {
            SettingModel *model = [SettingModel new];
            model.name = [titles objectAtIndex:i];
            model.state = 0;
            [self.titleModels addObject:model];
        }
    }
    return self;
}

- (BOOL)startConfig {
//    if (self.networkManager) {
//        [self.resetCommand execute:nil];
//        return false;
//    }
    self.networkManager = [AFNetworkReachabilityManager managerForDomain:@"www.baidu.com"];
    [self.networkManager startMonitoring];
    @weakify(self);
    [self.networkManager  setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可用");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"无线网络");
            {
                @strongify(self);
                self.currentWifiName = [[AppShare shareInstance] getCurrentWifiName];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"4g");
                break;
            default:
                break;
        }
    }];
    
    _connectingType = ConnectingTypeNone;
    //        _isLocal = YES;
    self.lanDeviceDict = [NSMutableDictionary dictionaryWithCapacity:0];
    self.WanDeviceDict = [NSMutableDictionary dictionaryWithCapacity:0];
    self.currentWifiName = [[AppShare shareInstance] getCurrentWifiName];
    //============初始化解码器
    //self.decodeSDK = [[HKDecodeSDK alloc] initWithDelegate:self];
    //self.displayView = [[HKDisplayView alloc] init];
    //        self.displayView.delegate = self;
    //============初始化局域网回调
    hk_InitLAN((__bridge void *)(self), &HKLanDataCallback);
    InitGetWifiSid((__bridge void *)(self), &HKWifiDataCallback);
    hk_InitWAN((__bridge void *)(self), &HKSystemCallback);
    hk_LanRefresh_EX(1);
    self.refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.lanDeviceDict removeAllObjects];
        hk_InitLAN((__bridge void *)(self), &HKLanDataCallback);
        //刷新局域网设备，当程序进入后台时，请调用hk_LanRefresh_EX(2);
        hk_LanRefresh_EX(1);
        return [RACSignal empty];
    }];
    self.selectDeviceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString * input) {
        @strongify(self);
        self.selectedDeviceID  = input;
        if (![[[AppShare shareInstance] getCurrentWifiName] isEqualToString:kDeviceWifiName]) {
            //网络可用
            [self.startVideoCommand execute:nil];
        }
        else
        {
            HekaiDeviceDesc *device = [self.lanDeviceDict objectForKey:input];
            DoLanGetWifiSid(device.deviceDesc.localDeviceId, [self.macWifi UTF8String], 0);
            
        }
        //            [self playVideo];
        return [RACSignal empty];
    }];
    self.setLanCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple * input) {
        WifiInfoModel * model = input.third;
        NSString * str = [NSString stringWithFormat:@"sid2=%@;pswd=%@;mac=%@;satype=%@;entype=%@;",input.first,input.second,self.macWifi,model.satype,model.entype];
        NSLog(@"%@",str);
        HekaiDeviceDesc *device = [self.lanDeviceDict objectForKey:self.selectedDeviceID];
        int state = SetLanWifi(1, 1, device.deviceDesc.localDeviceId, [str UTF8String]);
        if (state == 0) {
            //设置成功
            UIAlertController * alertCtrl = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"请在设备重启后->连接%@->点击刷新",input.first]  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                self.lanDeviceDict = [NSMutableDictionary dictionary];
                self.selectedDeviceID = nil;
                if (self.nextStepSuccess) {
                    self.nextStepSuccess();
                }
                hk_LanRefresh_EX(1);
            }];
            [alertCtrl addAction:sureAction];
            [(SHARED_APP_DELEGATE).window.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
            
        }else
        {
            
        }
        return [RACSignal empty];
    }];
    self.resetCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        HekaiDeviceDesc *device = [self.lanDeviceDict objectForKey:self.selectedDeviceID];
        SetLanWifi(1, 0, device.deviceDesc.localDeviceId, "");
        return [RACSignal empty];
    }];
    self.openLightCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton * input) {
        @strongify(self);
        HekaiDeviceDesc *device = [self.lanDeviceDict objectForKey:self.selectedDeviceID];
        input.selected = !input.selected;
        hk_LanAperture(device.deviceDesc.localDeviceId,input.selected,0);
        return [RACSignal empty];
    }];
    self.listDataChannel = [[RACChannel alloc] init];
    return true;
}

@end
