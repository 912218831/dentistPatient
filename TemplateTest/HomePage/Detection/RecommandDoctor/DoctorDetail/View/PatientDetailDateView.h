//
//  PatientDetailDateCell.h
//  TemplateTest
//
//  Created by HW on 17/9/6.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseView.h"

#define kPatientDetailDateCellHeight kRate(272/2.0)

@interface PatientDetailDateView : BaseView
@property (nonatomic, strong)RACSignal *valueSignal;
@end

@interface UILabelWithCorner : UIControl
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic,assign) UIRectCorner corner;
@end
