//
//  HWHomePageBannerModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/20.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseModel.h"
/*
 "imageurl":"http://abc.com/123.jpg",
 "targetUrl":"http://qbc.com/aa.html",

 */
@interface HWHomePageBannerModel : BaseModel
@property(strong,nonatomic)NSString * imageurl;
@property(strong,nonatomic)NSString * targetUrl;

@end
