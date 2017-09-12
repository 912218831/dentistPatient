//
//  CaseItemModel.h
//  TemplateTest
//
//  Created by HW on 17/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseModel.h"

@interface CaseItemModel : BaseModel
@property (nonatomic, copy)   NSString *Id;
@property (nonatomic, copy)   NSString *patintId;
@property (nonatomic, copy)   NSString *time;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, copy)   NSString *imageUrl;
@property (nonatomic, copy)   NSString *machineReport;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy)   NSString *patintName;
@end
