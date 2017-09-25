//
//  DoctorAbstractInfoView.h
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseView.h"

@interface DoctorAbstractInfoView : BaseView
@property (nonatomic, strong) RACSignal *valueSignal;
@end

@interface DoctorAbstractButton : UIButton
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat spaceX;
@property (nonatomic, assign) CGSize iconSize;
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) CGRect titleFrame;
@end
