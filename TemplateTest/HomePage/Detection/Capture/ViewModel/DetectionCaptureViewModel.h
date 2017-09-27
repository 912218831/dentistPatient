//
//  DetectionViewModel.h
//  TemplateTest
//
//  Created by HW on 17/9/15.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseViewModel.h"
#import "DetectionCaptureModel.h"
#import "FamilyMemberModel.h"

@interface DetectionCaptureViewModel : BaseListViewModel
@property (nonatomic, strong) FamilyMemberModel *model;
@property (nonatomic, copy)   NSString *checkId;
@property (nonatomic, strong) RACCommand *deletePhotoCommand;
@property (nonatomic, strong) RACSubject *canNextStepSignal;
@property (nonatomic, assign) BOOL canNextStep;
- (void)takePhotoSuccess:(UIImage *)image;
@end
