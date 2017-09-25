//
//  WechatUserInfo.h
//  TemplateTest
//
//  Created by HW on 17/9/23.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseModel.h"

@interface WechatUserInfo : BaseModel
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *headimgurl;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *unionid;
@end
