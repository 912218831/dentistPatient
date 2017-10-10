//
//  HWHomePageViewModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseViewModel.h"

@interface HWHomePageViewModel : BaseViewModel

@property(strong,nonatomic)NSArray * bannerModels;//banner
@property(strong,nonatomic)NSArray * pushitems;//为你推荐
@property(strong,nonatomic)NSArray * lastRecords;//最近记录
@property(strong,nonatomic)RACCommand * bannerCommand; //banner位点击
@property(strong,nonatomic)RACCommand * pushItemCommand; //推荐点击
@property(strong,nonatomic)RACCommand * funcBtnCommand;
@property(strong,nonatomic)RACCommand * selectCityCommand;
@property(strong,nonatomic)RACCommand * searchDocCommand;//搜索

@end
