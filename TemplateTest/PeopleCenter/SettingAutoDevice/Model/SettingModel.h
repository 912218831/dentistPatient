//
//  SettingModel.h
//  TemplateTest
//
//  Created by HW on 2017/11/4.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL state;// 0 未完成 -- 1 成功
@end
