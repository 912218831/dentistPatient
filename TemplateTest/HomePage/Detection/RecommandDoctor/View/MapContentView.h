//
//  MapContentView.h
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseView.h"

@interface MapContentView : UIButton
@property (nonatomic, strong) RACSignal *annotationsSignal;
@property (nonatomic, assign) BOOL needAnnotationCenter;
@property (nonatomic, strong) RACSubject *locationSuccess;
@property (nonatomic, strong) RACSubject *locationFail;
@end
