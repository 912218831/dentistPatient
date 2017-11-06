//
//  SettingDeviceViewModel.h
//  TemplateTest
//
//  Created by HW on 2017/11/4.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "TimeVideoViewModel.h"
#import "SettingModel.h"

@interface SettingDeviceViewModel : TimeVideoViewModel
@property (nonatomic, strong) NSMutableArray *titleModels;
@property (nonatomic, copy) void (^nextStepSuccess)();
- (BOOL)startConfig;

@end
