//
//  HWHomePagePushItemModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/20.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseModel.h"
/*
 "imageurl":"http://abc.com/123.jpg",
 "targetUrl":"http://qbc.com/aa.html",
 "title":"为你推荐的标题",

 */
@interface HWHomePagePushItemModel : BaseModel
@property(copy,nonatomic)NSString * imageurl;
@property(copy,nonatomic)NSString * targetUrl;
@property(copy,nonatomic)NSString * title;

@end
