//
//  HWPeopleCenterHeadView.h
//  TemplateTest
//
//  Created by HW on 17/9/10.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseView.h"
#import "DoctorAbstractInfoView.h"

@interface HWPeopleCenterHeadView : BaseView
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) DoctorAbstractButton *scoreBtn;
@end
