//
//  HWPeopleCenterViewModel.h
//  TemplateTest
//
//  Created by HW on 17/9/10.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseViewModel.h"
#import "HWPeopleCenterModel.h"

@interface HWPeopleCenterViewModel : BaseViewModel
@property (nonatomic, strong) HWPeopleCenterModel *model;
@property (nonatomic, copy) NSURL *headImageUrl;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, strong) RACCommand *loginOutCommand;
@property (nonatomic, strong) RACCommand *setPassword;
@property (nonatomic, strong) RACCommand *familyJump;
@property (nonatomic, strong) RACCommand *setting;
@property (nonatomic, strong) RACCommand *scoreTouch;
@end
