//
//  RecommandDoctorViewModel.h
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseListViewModel.h"

@interface RecommandDoctorViewModel : BaseListViewModel
@property (nonatomic, assign) CLLocationCoordinate2D coordinate2D;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, copy)   NSString *checkId;
@end
