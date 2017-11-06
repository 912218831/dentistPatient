//
//  TimeVideoViewModel.h
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseViewModel.h"
#import "HKDisplayView.h"
#import "HKCameraControl.h"
#import "HKDecodeSDK.h"
#import "hkipc.h"
#import "HKDisplayView.h"
#import "avrecord.h"
#import <sys/time.h>
#import "WifiInfoModel.h"
#import "WifiListView.h"

extern void HKLanDataCallback(void *userData, char *devid, char *devType, int hkid, int iCount,int iStatus,char *audioType );
extern void HKWifiDataCallback(void *userData, char *cBuf, int iLen);
extern void HKSystemCallback(void *userData, int nCmd, char *cBuf, int iLen);

@interface TimeVideoViewModel : BaseViewModel<HKDisplayViewDelegate> {
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
@property(strong,nonatomic,readwrite)HKDisplayView * displayView;
@property (nonatomic, strong) HKDecodeSDK *decodeSDK;
@property (nonatomic, strong) NSMutableDictionary *lanDeviceDict;
@property (nonatomic, strong) NSMutableDictionary *WanDeviceDict;//外网设备列表
@property (nonatomic, strong) HKCameraControl *cameraControl;
@property (nonatomic, strong) HekaiDeviceDesc *operationDevice;
@property (nonatomic, copy) NSString *selectedDeviceID;
@property(strong,nonatomic)NSString * macWifi;
@property(strong,nonatomic)WifiListView * wifiListView;
@property(strong,nonatomic)NSArray * wifiList;
@property(strong,nonatomic)AFNetworkReachabilityManager * networkManager;
@property(strong,nonatomic)NSString * currentWifiName;
@property(nonatomic,assign)BOOL needInitConfig;
//
@property(strong,nonatomic)RACCommand * refreshCommand;

@property(strong,nonatomic)RACChannel * listDataChannel;
@property(strong,nonatomic)RACCommand * selectDeviceCommand;
@property(strong,nonatomic)RACCommand * setLanCommand;
@property (nonatomic, strong) UIImage *captureImage;
@property(strong,nonatomic)RACCommand * startVideoCommand;//开始录像
@property(strong,nonatomic)RACCommand * quitVideo;//退出录像
@property(strong,nonatomic)RACCommand * resetCommand;
@property(strong,nonatomic)RACCommand * openLightCommand;

@property (nonatomic, copy) void (^takePhoto)(UIImage *image);
@end
