//
//  HWHomePageLastRecordModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/20.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseModel.h"
/*
 id = 469;
 imageCount = 0;
 imageUrl = "<null>";
 machineReport = 0;
 patintId = 6;
 patintName = dazhang;
 thumbnailUrl = "http://test.jpg";
 time = "2017-10-09 15:18:55";
 */
@interface HWHomePageLastRecordModel : BaseModel
@property(strong,nonatomic)NSString * recodeId;
@property(strong,nonatomic)NSString * time;
@property(copy,nonatomic)NSString * imageCount;
@property(copy,nonatomic)NSString * machineReport;
@property(copy,nonatomic)NSString * patintId;
@property(copy,nonatomic)NSString * thumbnailUrl;
@property(copy,nonatomic)NSString * imageurl;
@property(copy,nonatomic)NSString * patintName;
//@property(copy,nonatomic)NSString * recodeDescription;

@end
