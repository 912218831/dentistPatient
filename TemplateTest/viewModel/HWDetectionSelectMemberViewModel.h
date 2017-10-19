//
//  HWDetectionSelectMemberViewModel.h
//  TemplateTest
//
//  Created by HW on 17/9/15.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseListViewModel.h"

@interface HWDetectionSelectMemberViewModel : BaseListViewModel
@property(nonatomic, strong)NSIndexPath *selectIndexPath;
@property(nonatomic, strong)dispatch_block_t detectActionBlock;
@property (nonatomic, strong) RACSignal *createCaseSignal;
@property(nonatomic, assign) NSInteger type;
@end
