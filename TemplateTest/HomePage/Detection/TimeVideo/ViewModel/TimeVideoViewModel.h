//
//  TimeVideoViewModel.h
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseViewModel.h"
#import "HKDisplayView.h"
@interface TimeVideoViewModel : BaseViewModel<HKDisplayViewDelegate>

@property(strong,nonatomic)RACCommand * refreshCommand;

@property(strong,nonatomic)RACChannel * listDataChannel;
@property(strong,nonatomic)RACCommand * selectDeviceCommand;
@property(strong,nonatomic)RACCommand * setLanCommand;
@property(strong,nonatomic,readonly)HKDisplayView * displayView;
@property (nonatomic, strong) UIImage *captureImage;
@property(strong,nonatomic)RACCommand * startVideoCommand;//开始录像
@property(strong,nonatomic)RACCommand * quitVideo;//退出录像
@property(strong,nonatomic)RACCommand * resetCommand;
@property(strong,nonatomic)RACCommand * openLightCommand;

@property (nonatomic, copy) void (^takePhoto)(UIImage *image);
@end
