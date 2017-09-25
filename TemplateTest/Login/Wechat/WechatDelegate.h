//
//  WechatDelegate.h
//  TemplateTest
//
//  Created by HW on 17/9/23.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WechatUserInfo.h"

#define kWechatAppId                @"wx21425826381112ad"
#define kWechatSecret               @"ddb9d383a60ecab8c290942048cf282f"
#define kWechatGrant_type           @"authorization_code"
#define kWechatAccessToken          @"https://api.weixin.qq.com/sns/oauth2/access_token"
#define kWechatGetUserInfo          @"https://api.weixin.qq.com/sns/userinfo"

@interface WechatDelegate : NSObject<WXApiDelegate>
@property (nonatomic, copy, readonly) NSString *access_token;
@property (nonatomic, copy, readonly) NSString *refresh_token;
@property (nonatomic, copy, readonly) NSString *openid;
@property (nonatomic, copy, readonly) NSString *unionid;
@property (nonatomic, strong, readonly) WechatUserInfo *userInfo;
+ (instancetype)shareWechatDelegate;

@end
