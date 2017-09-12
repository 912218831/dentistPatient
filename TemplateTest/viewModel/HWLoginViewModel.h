//
//  HWLoginViewModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/11.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "HWLoginCellViewModel.h"
@interface HWLoginViewModel : BaseViewModel

@property(strong,nonatomic)HWLoginCellViewModel * loginCellModel;
@property(strong,nonatomic)RACCommand * loginCommand;
@end
