//
//  DetectionViewModel.h
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseViewModel.h"
#import "DetectionIssueItemModel.h"

@interface DetectionResultViewModel : BaseViewModel
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL detectionResultState;// 1 是很好，0 是有问题
@end
