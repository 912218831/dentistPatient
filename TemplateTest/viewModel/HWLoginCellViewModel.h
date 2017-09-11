//
//  HWLoginCellViewModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/11.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface HWLoginCellViewModel : RVMViewModel

@property(strong,nonatomic)NSString * telphone;
@property(strong,nonatomic)NSString * verifyCode;
@property(strong,nonatomic)RACCommand * verifyCodeCommand;

@end
