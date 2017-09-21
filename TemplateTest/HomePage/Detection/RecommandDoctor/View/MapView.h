//
//  MapView.h
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseListViewCell.h"

@interface MapView : BaseListViewCell
@property (nonatomic, strong, readonly) RACSubject *locationSuccess;
@property (nonatomic, strong, readonly) RACSubject *locationFail;
@end
