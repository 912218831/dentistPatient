//
//  WechatDelegate.h
//  TemplateTest
//
//  Created by HW on 17/9/23.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WechatUserInfo.h"

#define kWechatAppId                @"wx6ac065be2671f37d"
#define kWechatSecret               @"f9f290cb5a5a88df9019834193ded275"
#define kWechatGrant_type           @"authorization_code"
#define kWechatAccessToken          @"https://api.weixin.qq.com/sns/oauth2/access_token"
#define kWechatGetUserInfo          @"https://api.weixin.qq.com/sns/userinfo"
#define kWechatPayInfo              @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios"
static inline void loginAction() {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"App";
    [WXApi sendReq:req];
}

@interface WechatDelegate : NSObject<WXApiDelegate>
@property (nonatomic, copy, readonly) NSString *expires_in;
@property (nonatomic, copy, readonly) NSString *access_token;
@property (nonatomic, copy, readonly) NSString *refresh_token;
@property (nonatomic, copy, readonly) NSString *openid;
@property (nonatomic, copy, readonly) NSString *unionid;
@property (nonatomic, strong, readonly) WechatUserInfo *userInfo;
@property (nonatomic, copy) void (^getInfoSuccess)();
+ (instancetype)shareWechatDelegate;

@end
