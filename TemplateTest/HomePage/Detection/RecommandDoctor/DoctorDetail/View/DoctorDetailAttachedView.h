//
//  DoctorDetailAttachedView.h
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseView.h"

typedef NS_ENUM(NSInteger, AttachedViewDirection){
    Left ,
    Right
} ;

@interface DoctorDetailAttachedView : BaseView
@property (nonatomic, assign) AttachedViewDirection direction;
@property (nonatomic, strong) RACSignal *valueSignal;
@end


@interface MoreSubView : BaseView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, assign) BOOL needShowIcon;
- (void)reloadData;
@end
