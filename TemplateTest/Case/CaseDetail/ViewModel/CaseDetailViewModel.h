//
//  CaseDetailViewModel.h
//  TemplateTest
//
//  Created by HW on 17/9/13.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseViewModel.h"
#import "CaseItemModel.h"
#import "CaseDetailModel.h"
#define kPhotoWith   (kRate(109))
#define kPhotoHeight (kRate(109))
#define kPhotoSpaceX (kRate(9))
#define kPhotoSpaceY (kRate(9))
#define kPhotoTitleY (kRate(14))
@interface CaseDetailViewModel : BaseViewModel
@property (nonatomic, strong) CaseDetailModel *model;
@property (nonatomic, strong) CaseItemModel *caseModel;
@property (nonatomic, assign) CGFloat imageCellHeight;

@property (nonatomic, strong) UIImage *waitUploadImage;
@property (nonatomic, strong) RACSignal *uploadImageSignal;
@end
