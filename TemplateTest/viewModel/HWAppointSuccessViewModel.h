//
//  HWAppointSuccessViewModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/21.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseViewModel.h"
#import "HWAppointDetailModel.h"
@interface HWAppointSuccessViewModel : BaseViewModel
@property(strong,nonatomic,readonly)HWAppointDetailModel * detailModel;
@property(strong,nonatomic)NSArray * coupons;
@property(strong,nonatomic)NSString * sumMoney;
@property(assign,nonatomic)BOOL isNeedRefreshList;//是否需要刷新列表
- (instancetype)initWithAppointId:(NSString *)appointId;

@end
