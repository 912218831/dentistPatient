//
//  HWLoginViewModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/11.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWLoginViewModel.h"
#import <YYModel/NSObject+YYModel.h>
@implementation HWLoginViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {

        
    }
    return self;
}

- (void)setLoginCellModel:(HWLoginCellViewModel *)loginCellModel
{
    if (_loginCellModel != loginCellModel) {
        _loginCellModel = loginCellModel;
        RACSignal * loginSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            if (_loginCellModel.telphone.length == 0) {
                [subscriber sendError:[NSError errorWithDomain:@"com.hw.com" code:100 userInfo:@{NSLocalizedDescriptionKey:@"请输入手机号"}]];
                ;
                return nil;
            }
            if (_loginCellModel.verifyCode.length == 0) {
                [subscriber sendError:[NSError errorWithDomain:@"com.hw.com" code:100 userInfo:@{NSLocalizedDescriptionKey:@"请输入验证码"}]];
                return nil;
            }
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [params setObject:_loginCellModel.telphone forKey:@"mobile"];
            [params setObject:_loginCellModel.verifyCode forKey:@"randCode"];
            
            [self post:kLogin type:1 params:params success:^(id response) {
                [subscriber sendNext:@"登录成功"];
                [[HWUserLogin currentUserLogin] yy_modelSetWithDictionary:[response dictionaryForKey:@"data"]];
                

            } failure:^(NSString * error) {
                [subscriber sendError:[NSError errorWithDomain:@"com.getLoginCode" code:100 userInfo:@{NSLocalizedDescriptionKey:error}]];
            }];
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"销毁");
            }];
        }];
        self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            return loginSignal;
        }];

    }
}

@end
