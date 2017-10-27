//
//  HWLoginViewModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/11.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "HWLoginCellViewModel.h"
typedef NS_ENUM(NSInteger, Type){
    Login , // 登录
    Bind    // 绑定
};
@interface HWLoginViewModel : BaseViewModel
@property (nonatomic, assign) BOOL firstFlag;
@property (nonatomic, assign) Type type;
@property(strong,nonatomic)HWLoginCellViewModel * loginCellModel;
@property(strong,nonatomic)RACCommand * loginCommand;
- (void)wechatLogin:(void(^)(NSString *error))finished;
@end
