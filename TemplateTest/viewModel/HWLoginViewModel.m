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
            if (self.type == Login) {
                [params setObject:_loginCellModel.telphone forKey:@"mobile"];
                [params setObject:_loginCellModel.verifyCode forKey:@"randCode"];
            } else {
                [params setObject:[WechatDelegate shareWechatDelegate].userInfo.unionid forKey:@"unionId"];
                [params setObject:[WechatDelegate shareWechatDelegate].userInfo.headimgurl forKey:@"headImageUrl"];
                [params setObject:[WechatDelegate shareWechatDelegate].userInfo.sex forKey:@"gender"];
                [params setObject:[WechatDelegate shareWechatDelegate].userInfo.nickname forKey:@"name"];
                [params setObject:[WechatDelegate shareWechatDelegate].access_token forKey:@"accessToken"];
                [params setObject:[WechatDelegate shareWechatDelegate].expires_in forKey:@"expiration"];
                NSString *sigStr = [NSString stringWithFormat:@"%@%@",[WechatDelegate shareWechatDelegate].userInfo.nickname,@"sxm1125"];
                NSString *sig = [sigStr md5:sigStr];
                [params setObject:sig forKey:@"sig"];
                [params setObject:_loginCellModel.telphone  forKey:@"mobile"];
                [params setObject:_loginCellModel.verifyCode forKey:@"verifyCode"];
            }
            [self post:self.type==Login?kLogin:kBindPhone type:1 params:params success:^(id response) {
                NSDictionary * dic = [response objectForKey:@"data"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[AppShare shareInstance] handelCurrentCoreDataLoginUser:^(HWLoginUser *loginUser) {
                        loginUser.key = [dic stringObjectForKey:@"userkey"];
                        loginUser.userPhone = _loginCellModel.telphone;
                    }];
                    [subscriber sendNext:@"登录成功"];
                });
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

- (void)wechatLogin:(void(^)(NSString *error))finished {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[WechatDelegate shareWechatDelegate].userInfo.unionid forKey:@"unionId"];
    [params setObject:[WechatDelegate shareWechatDelegate].userInfo.headimgurl forKey:@"headImageUrl"];
    [params setObject:[WechatDelegate shareWechatDelegate].userInfo.sex forKey:@"gender"];
    [params setObject:[WechatDelegate shareWechatDelegate].userInfo.nickname forKey:@"name"];
    [params setObject:[WechatDelegate shareWechatDelegate].access_token forKey:@"accessToken"];
    [params setObject:[WechatDelegate shareWechatDelegate].expires_in forKey:@"expiration"];
    NSString *sigStr = [NSString stringWithFormat:@"%@%@",[WechatDelegate shareWechatDelegate].userInfo.nickname,@"sxm1125"];
    NSString *sig = [sigStr md5:sigStr];
    [params setObject:sig forKey:@"sig"];
    @weakify(self);
    [self post:kWechatLogin type:1 params:params success:^(NSDictionary *response) {
        @strongify(self);
        NSDictionary *data = [response dictionaryObjectForKey:@"data"];
        [[AppShare shareInstance] handelCurrentCoreDataLoginUser:^(HWLoginUser *loginUser) {
            loginUser.key = [data stringObjectForKey:@"userkey"];
            loginUser.userPhone = _loginCellModel.telphone;
        }];
        NSString *firstFlag = [data stringObjectForKey:@"firstFlag"];
        self.firstFlag = [firstFlag isEqualToString:@"true"]||[firstFlag integerValue];
        finished(nil);
    } failure:^(NSString *error) {
        finished(error);
    }];
}

@end
