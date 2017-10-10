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
@property(strong,nonatomic)RACCommand * playVideoCommand;
@property(strong,nonatomic,readonly)HKDisplayView * displayView;


@end
