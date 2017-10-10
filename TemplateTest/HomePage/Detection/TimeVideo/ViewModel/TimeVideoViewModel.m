//
//  TimeVideoViewModel.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "TimeVideoViewModel.h"
#import "HKCameraControl.h"
#import "HKDecodeSDK.h"
#import "hkipc.h"
#import "HKDisplayView.h"
#import "avrecord.h"
#import <sys/time.h>
#import "WifiInfoModel.h"
#import "WifiListView.h"
@interface TimeVideoViewModel()<HKDecodeSDKDelegate, HKDisplayViewDelegate,WifiListViewDelegate,UIWebViewDelegate>
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

@end

@implementation TimeVideoViewModel


//局域网设备节点回调函数
static void HKLanDataCallback(void *userData, char *devid, char *devType, int hkid, int iCount,int iStatus,char *audioType )
{
    if (userData == NULL) {
        return;
    }
    TimeVideoViewModel *p = (__bridge TimeVideoViewModel *)userData;
    
    if (strcmp("301", devid) == 0) {
        //忽略301信息
        return;
    }
    
    HEKAI_DEVICE_DESC deviceDesc;
    memset(&deviceDesc, 0x0, sizeof (deviceDesc));
    
    strcpy(deviceDesc.alias, devid);
    strcpy(deviceDesc.deviceId, devid);
    strcpy(deviceDesc.deviceType, devType);
    deviceDesc.isLocalDevice = 1;
    deviceDesc.localDeviceId = hkid;
    deviceDesc.chanNum = iCount;
    deviceDesc.isOnline = (1 == iStatus || 2 == iStatus) ? 1 : 0;
    
    if (0 == strcmp(audioType, "PCM")) {
        deviceDesc.audioType = HEKAI_AUDIO_PCM;
    } else if (0 == strcmp(audioType, "G711")) {
        deviceDesc.audioType = HEKAI_AUDIO_G711A;
    } else if (0 == strcmp(audioType, "G726")) {
        deviceDesc.audioType = HEKAI_AUDIO_G726;
    } else if (0 == strcmp(audioType, "G729")) {
        deviceDesc.audioType = HEKAI_AUDIO_G729;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [p handleHKLanDataCallback:deviceDesc];
    });
}
/*typedef void (*HKWIFISIDCALLBACK)(void *userData, char *cBuf, int iLen );
 */
static void HKWifiDataCallback(void *userData, char *cBuf, int iLen)
{
    TimeVideoViewModel *p = (__bridge TimeVideoViewModel *)userData;
    if (cBuf != NULL) {
        NSString * wifiInfoStr = [NSString stringWithFormat:@"%s",cBuf];
        NSArray * wifiInfoArr = [wifiInfoStr componentsSeparatedByString:@":"];
        NSMutableSet * tempset = [NSMutableSet set];
        for (NSString * str in wifiInfoArr) {
            for (NSString * substr in [str componentsSeparatedByString:@","]) {
                [tempset addObject:substr];
            }
            
        }
        if (![p.wifiList isEqualToArray:[tempset allObjects]]) {
            NSMutableArray * tempmutableArr = [NSMutableArray array];
            for (NSString * str3 in [tempset allObjects]) {
                WifiInfoModel * model = [[WifiInfoModel alloc] initWithInfo:str3];
                model.macInfo = p.macWifi;
                [tempmutableArr addObject:model];
            }
            p.wifiListView.dataArr = [tempmutableArr copy];
            if ( p.wifiListView.frame.origin.y == [UIScreen mainScreen].bounds.size.height) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.3 animations:^{
                        p.wifiListView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-300, [UIScreen mainScreen].bounds.size.width, 300);
                    }];

                });
            }
        }
    }
}
static void HKSystemCallback(void *userData, int nCmd, char *cBuf, int iLen)
{
    TimeVideoViewModel *p = (__bridge TimeVideoViewModel *)userData;
    [p handleSystemCallback:nCmd withBuf:cBuf withiLen:iLen];
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        UIWebView * web = [[UIWebView alloc] initWithFrame:CGRectMake(200, 0, 100, 100)];
//        [self.view addSubview:web];
//        web.delegate = self;
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
        _connectingType = ConnectingTypeNone;
//        _isLocal = YES;
        self.lanDeviceDict = [NSMutableDictionary dictionaryWithCapacity:0];
        self.WanDeviceDict = [NSMutableDictionary dictionaryWithCapacity:0];
        //============初始化解码器
        self.decodeSDK = [[HKDecodeSDK alloc] initWithDelegate:self];
        self.displayView = [[HKDisplayView alloc] init];
        self.displayView.delegate = self;
        //============初始化局域网回调
        hk_InitLAN((__bridge void *)(self), &HKLanDataCallback);
        InitGetWifiSid((__bridge void *)(self), &HKWifiDataCallback);
        hk_InitWAN((__bridge void *)(self), &HKSystemCallback);
        @weakify(self);
        self.refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            [_lanDeviceDict removeAllObjects];
            int initState = hk_InitLAN((__bridge void *)(self), &HKLanDataCallback);
            //刷新局域网设备，当程序进入后台时，请调用hk_LanRefresh_EX(2);
            int state = hk_LanRefresh_EX(1);
            return [RACSignal empty];
        }];
        self.playVideoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString * input) {
            @strongify(self);
            self.selectedDeviceID  = input;
            [self playVideo];
            return [RACSignal empty];
        }];
        self.listDataChannel = [[RACChannel alloc] init];
    }
    return self;
}

- (void)handleHKLanDataCallback:(HEKAI_DEVICE_DESC)desc
{
    NSString *deviceID = [NSString stringWithUTF8String:desc.deviceId];
    self.selectedDeviceID = deviceID;
    if ([_lanDeviceDict.allKeys containsObject:deviceID]) {
        //如果不是新设备，则只是更新设备里的数据，目前局域网设备只有hkid会更新
        HekaiDeviceDesc *existDevice = [_lanDeviceDict objectForKey:deviceID];
        if (existDevice.deviceDesc.localDeviceId != desc.localDeviceId) {
            HEKAI_DEVICE_DESC desc = existDevice.deviceDesc;
            desc.localDeviceId = desc.localDeviceId;
            existDevice.deviceDesc = desc;
        }
        
    } else {
        NSLog(@"发现新设备 %@", deviceID);
        HekaiDeviceDesc *device = [[HekaiDeviceDesc alloc] init];
        device.deviceDesc = desc;
        [_lanDeviceDict setObject:device forKey:deviceID];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listDataChannel.followingTerminal sendNext:_lanDeviceDict];
        });
    }
    char deviceInfo[1024];
    GetLanSysInfo(deviceInfo,201,[deviceID UTF8String]);
    NSString * deviceInfoStr = [NSString stringWithFormat:@"%s",deviceInfo];
    
    NSArray * deviceInfoArr = [deviceInfoStr componentsSeparatedByString:@";"];
    NSString * macStr;
    for (NSString * su in deviceInfoArr) {
        NSLog(@"%@",su);
        if ([su hasPrefix:@"mac"]) {
            macStr = [su substringFromIndex:4];
            break;
        }
    }
    
    NSLog(@"%@",macStr);
    self.macWifi = macStr;
    DoLanGetWifiSid(desc.localDeviceId, [macStr UTF8String], 0);
}


//hk_StartLogin---->nCmd; 0 成功，1密码错误，3网络不通，14 网络断开. cBuf =NULL,iLen=0;
- (void)handleSystemCallback:(int)nCmd withBuf:(char *)cBuf withiLen:(int)iLen
{
    NSLog(@"======ncmd %d cbuf %s", nCmd, cBuf);
    switch (nCmd) {
        case 0:
            //登录成功
            break;
        case 3:
            //网络不通
            NSLog(@"网络不通，请稍后再试");
            break;
        case 102:
        {
            NSLog(@"设备列表");
            [self procWanDeviceListInfo:cBuf totalCount:iLen];
        }
            break;
        case 105:
        case 106:
        {
            NSString *strBuf = [NSString stringWithUTF8String:cBuf];
            strBuf = (NSString *)[[strBuf componentsSeparatedByString:@"flag="] objectAtIndex:1];
            NSLog(@"系统回调返回 %d", nCmd);
            [self procWanVideoConnectCommand:nCmd withFlag:strBuf.intValue];
        }
            break;
            
        case 101:
        {
            if (strcmp(cBuf, "1") == 0) {
                NSLog(@"注册监控服务成功");
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    [self registMoniterSuccess:ConnectingTypeRegistServerSuccess];
                });
            } else {
                NSLog(@"注册监控服务失败");
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    [self registMoniterSuccess:ConnectingTypeRegistServerFail];
                });
            }
            
        }
            break;
        case 119:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
//                _textView.text = [NSString stringWithUTF8String:cBuf];
            });
        }
            break;
        default:
            break;
    }
}


- (void)procWanDeviceListInfo:(char *)deviceInfo totalCount:(int)iTotal
{
    @synchronized(self){
        if (strcmp(deviceInfo, "0") == 0) {
            NSLog(@"该用户下没有设备......");
        }
        
        int iCount, iFormid;
        char cDevType[64] = {0};
        char cAlias[64] = {0};
        char cDevid[64] = {0};
        char cDeviceAccessPwd[64] = {0};
        char cUserAccessPwd[64] = {0};
        char audioType[12] = {0};
        int isAdminDev, isOnline, popedom;
        const char *fmt = "DevFlag%%equal%%%[^%]%%comma%%formid%%equal%%%d%%comma%%alias%%equal%%%[^%]%%comma%%devid%%equal%%%[^%]%%comma%%Count%%equal%%%d%%comma%%type%%equal%%2%%comma%%audio%%equal%%%[^%]%%comma%%admin%%equal%%%d%%comma%%status%%equal%%%d%%comma%%popedom%%equal%%%d%%comma%%devAccess%%equal%%%[^%]%%comma%%userAccess%%equal%%%[^%]";
        sscanf(deviceInfo, fmt, cDevType, &iFormid, cAlias, cDevid, &iCount, audioType, &isAdminDev, &isOnline, &popedom);
        
        NSString *deviceID = [NSString stringWithUTF8String:cDevid];
        NSString *strAlias = [[NSString alloc] initWithBytes:cAlias length:strlen(cAlias) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        //                NSString *strVideoType = [NSString stringWithUTF8String:cDevType];
        //                NSString *strAudioType = [NSString stringWithUTF8String:audioType];
        //                NSString *strDevAccessPwd = [NSString stringWithUTF8String:cDeviceAccessPwd];
        //                NSString *strUserAccessPwd = [NSString stringWithUTF8String:cUserAccessPwd];
        
        HEKAI_DEVICE_DESC deviceDesc;
        memset(&deviceDesc, 0x0, sizeof (deviceDesc));
        strcpy(deviceDesc.alias, cAlias);
        strcpy(deviceDesc.deviceId, cDevid);
        strcpy(deviceDesc.deviceType, cDevType);
        deviceDesc.isLocalDevice = 0;
        deviceDesc.localDeviceId = 0;
        deviceDesc.chanNum = iCount;
        deviceDesc.isOnline = isOnline;
        
        if (0 == strcmp(audioType, "PCM")) {
            
            deviceDesc.audioType = HEKAI_AUDIO_PCM;
            
        } else if (0 == strcmp(audioType, "G711")) {
            
            deviceDesc.audioType = HEKAI_AUDIO_G711A;
            
        } else if (0 == strcmp(audioType, "G726")) {
            
            deviceDesc.audioType = HEKAI_AUDIO_G726;
            
        } else if (0 == strcmp(audioType, "G729")) {
            
            deviceDesc.audioType = HEKAI_AUDIO_G729;
            
        }
        
        HekaiDeviceDesc *device = [[HekaiDeviceDesc alloc] init];
        device.deviceDesc = deviceDesc;
        [_WanDeviceDict setObject:device forKey:deviceID];
        
        
        //刷新设备列表
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_deviceListTableView reloadData];
//        });
        
    }
    
}


- (void)procWanVideoConnectCommand:(int)nCmd withFlag:(int)flag
{
    int type = _connectingType;
    _connectingType = ConnectingTypeNone;
    
    if (nCmd == 105) {
        if (flag == 5 || flag == 6 || flag == 7) {
            //105返回成功，继续等待106 ConnectingTypeVideoWait105 / ConnectingTypeAudioWait105
            
            if (type == ConnectingTypeVideoWait105) {
                _connectingType = ConnectingTypeVideoWait106;
                
            } else if (type == ConnectingTypeListenAudioWait105) {
                _connectingType = ConnectingTypeListenAudioWait106;
                
            } else if (type == ConnectingTypeSpeakerAudioWait105) {
                _connectingType = ConnectingTypeSpeakerAudioWait106;
                
            } else {
                NSLog(@"成功了，这是什么105类型----->%d", type);
            }
        } else {
            //105返回失败
            if (type == ConnectingTypeVideoWait105) {//视频105
                [self openVideoFailed];
                
            } else if (type == ConnectingTypeListenAudioWait105) {//音频105
//                [self openListenAudioFailed];
                
            } else if (type == ConnectingTypeSpeakerAudioWait105) {//音频105
//                [self openSpeakerAudioFailed];
                
            } else {
                NSLog(@"失败了，这是什么105类型--->%d", type);
            }
        }
    } else if (nCmd == 106) {
        if (flag == 1) {
            //106返回成功，音视频呼叫成功
            if (type == ConnectingTypeVideoWait106) {//视频106
                [self openVideoSuccess];
                
            } else if (type == ConnectingTypeListenAudioWait106) {//音频106
//                [self openListenAudioSuccess];
                
            } else if (type == ConnectingTypeSpeakerAudioWait106) {//音频106
//                [self openSpeakerAudioSuccess];
                
            } else {
                NSLog(@"成功了，但这是什么106类型--->%d", type);
            }
        } else {
            //106返回失败
            if (type == ConnectingTypeVideoWait106) {//视频106
                [self openVideoFailed];
                
            } else if (type == ConnectingTypeListenAudioWait106) {//音频106
//                [self openListenAudioFailed];
                
            } else if (type == ConnectingTypeSpeakerAudioWait106) {//音频106
//                [self openSpeakerAudioFailed];
                
            } else {
                NSLog(@"失败了，可这是什么106类型--->%d", type);
            }
        }
    }
}

- (void)openVideoSuccess
{
//    _operationDeviceLabel.text = [NSString stringWithUTF8String:_operationDevice.deviceDesc.deviceId];
    
    //1、把视频callid加到解码器中，解码器会把解码和未解码的数据都从代理方法中返回
    [_decodeSDK addCallID:_operationDevice.videoCallid];
    
//    [self enableOperation:YES];
}

- (void)openVideoFailed
{
    _connectingType = ConnectingTypeNone;
    _operationDevice.videoCallid = nil;
    self.operationDevice = nil;
    self.cameraControl = nil;
    
//    [self enableOperation:NO];
}

- (void)playVideo{
    [self stopVideo];
    self.operationDevice = [_lanDeviceDict objectForKey:_selectedDeviceID];
    self.cameraControl = [[HKCameraControl alloc] initWithDeviceID:_selectedDeviceID hkid:_operationDevice.deviceDesc.localDeviceId asLocalDevice:_operationDevice.deviceDesc.isLocalDevice];
    _connectingType = ConnectingTypeNone;
    BOOL bMainStream = YES;//主/子码流方式呼叫
    int ret = -1;
    char callid[64] = {0};
    if (_operationDevice.deviceDesc.isLocalDevice) {
        //局域网设备呼叫视频
        ret = hk_DoLanInvite_EX(callid, _operationDevice.deviceDesc.localDeviceId, _operationDevice.deviceDesc.deviceType, 0, bMainStream);
        if (ret < 0) {
            self.operationDevice = nil;
            self.cameraControl = nil;
            [Utility showToastWithMessage:@"局域网设备呼叫视频失败"];
        } else {
            _operationDevice.videoCallid = [NSString stringWithUTF8String:callid];
            [self openVideoSuccess];
        }
    } else {
        //互联网呼叫视频
    }

}


- (void)stopVideo{
    //1、把视频callid从解码器中移除
    [_decodeSDK removeCallID:_operationDevice.videoCallid];
    _connectingType = ConnectingTypeNone;
    //2、关闭视频，其实关闭视频与音频的接口都是一样的，只不过callid不同
    if (_operationDevice.deviceDesc.isLocalDevice) {
        hk_DoLanClose(_operationDevice.videoCallid.UTF8String);
    } else {
        hk_DoMonCloseDialog(_operationDevice.deviceDesc.deviceId, (char *)_operationDevice.videoCallid.UTF8String);
    }
//    _operationDeviceLabel.text = nil;
    _operationDevice.videoCallid = nil;
    self.operationDevice = nil;
    self.cameraControl = nil;
}

#pragma mark - HKDecodeSDKDelegate

//未解码的原始视频数据
- (void)DecodeSDK:(HKDecodeSDK *)sdk recordDataCallback:(const SCC_MideData *)data
{
    NSLog(@"record data.....");
//    if(_isRecord == YES){
//        [_displayView handleRecordData:data->pDataBuf length:data->nSize frametype:data->nFreamType];
//    }
    
}

//解码了的视频数据
- (void)DecodeSDK:(HKDecodeSDK *)sdk CallID:(NSString *)callid decodedMediaData:(RENDER_FRAME_DESC *)frameDesc
{
    
    [_displayView displayVideo:frameDesc->media videoWidth:frameDesc->frameWidth videoHeight:frameDesc->frameHeight];
}

//解码后的PCM格式的音频数据
- (void)DecodeSDK:(HKDecodeSDK *)sdk decodedAudioData:(RENDER_FRAME_DESC *)frameDesc
{
    //                NSLog(@"audio frameDesc->length %d, frameDesc->media %p", frameDesc->length, frameDesc->media);
    [_displayView playListenAudio:frameDesc->media length:frameDesc->length];
}
@end
