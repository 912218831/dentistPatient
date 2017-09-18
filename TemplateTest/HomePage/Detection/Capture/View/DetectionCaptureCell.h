//
//  DetectionCaptureCell.h
//  TemplateTest
//
//  Created by HW on 17/9/15.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetectionCaptureCell : UICollectionViewCell
@property (nonatomic, strong, readonly) UIImageView *photoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) RACSignal *valueSignal;
@property (nonatomic, strong) RACSubject *deleteActionSubject;
@property (nonatomic, assign) BOOL needBorder;
@end
