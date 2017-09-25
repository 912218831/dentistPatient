//
//  WechatDelegate.m
//  TemplateTest
//
//  Created by HW on 17/9/23.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "WechatDelegate.h"

@interface WechatDelegate ()
@property (nonatomic, copy, readwrite) NSString *access_token;
@property (nonatomic, copy, readwrite) NSString *refresh_token;
@property (nonatomic, copy, readwrite) NSString *openid;
@property (nonatomic, copy, readwrite) NSString *unionid;
@property (nonatomic, strong, readwrite) WechatUserInfo *userInfo;
@end

@implementation WechatDelegate

+ (instancetype)shareWechatDelegate {
    static WechatDelegate *delegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (delegate == nil) {
            delegate = [WechatDelegate new];
        }
    });
    return delegate;
}

- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(SendAuthResp *)resp {
    
    [HWHTTPSessionManger shareHttpClient].responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    [[HWHTTPSessionManger shareHttpClient]HWPOST:kWechatAccessToken parameters:
            @{@"appid":kWechatAppId,
              @"secret":kWechatSecret,
              @"code":resp.code,
              @"grant_type":kWechatGrant_type}
                                         success:^(NSDictionary *responese) {
                                             self.access_token = [responese stringObjectForKey:@"access_token"];
                                             self.refresh_token = [responese stringObjectForKey:@"refresh_token"];
                                             self.unionid = [responese stringObjectForKey:@"unionid"];
                                             self.openid = [responese stringObjectForKey:@"openid"];
                                             
                                             [self requestUserInfo];
                                          }
                                         failure:^(NSString *code, NSString *error) {
                                               NSLog(@"error-%@",error);
                                         }];
}

- (void)requestUserInfo {
    [[HWHTTPSessionManger shareHttpClient]HWPOST:kWechatGetUserInfo parameters:
     @{@"access_token":self.access_token,
       @"openid":self.openid}
                                         success:^(NSDictionary *responese) {
                                             self.userInfo = [[WechatUserInfo alloc]initWithDictionary:responese error:nil];
                                         }
                                         failure:^(NSString *code, NSString *error) {
                                             NSLog(@"error-%@",error);
                                         }];
}

@end
