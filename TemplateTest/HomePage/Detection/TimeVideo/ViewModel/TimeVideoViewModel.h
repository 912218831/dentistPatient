//
//  TimeVideoViewModel.h
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseViewModel.h"

@interface TimeVideoViewModel : BaseViewModel
@property (nonatomic, strong) UIImage *captureImage;
@property (nonatomic, copy) void (^takePhoto)(UIImage *image);
@end
