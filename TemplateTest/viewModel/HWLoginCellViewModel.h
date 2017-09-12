//
//  HWLoginCellViewModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/11.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface HWLoginCellViewModel : BaseViewModel

@property(strong,nonatomic)NSString * telphone;
@property(strong,nonatomic)NSString * verifyCode;
@property(strong,nonatomic)RACCommand * verifyCodeCommand;
@property(assign,nonatomic,readonly)BOOL canReGain; //是否可以重新点击
@property(strong,nonatomic,readonly)NSString * title;//倒计时按钮的标题
@end
