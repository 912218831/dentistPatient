//
//  HWCasesViewModel.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseListViewModel.h"
#import "CaseItemModel.h"
#import "FamilyMemberModel.h"

@interface HWCasesViewModel : BaseListViewModel
@property (nonatomic, strong) RACCommand *gainFamilyMember;
@property (nonatomic, strong) NSArray *familyMember;
@property (nonatomic, assign) NSInteger familyMemberIndex;// 从 1 开始
@end
