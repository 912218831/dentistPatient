//
//  DetectionCaptureModel.h
//  TemplateTest
//
//  Created by HW on 17/9/15.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseModel.h"

@interface DetectionCaptureModel : BaseModel
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *machinereturn;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL needUpload;// 是否需要上传
@property (nonatomic, assign) BOOL uploadSuccess;// 上传成功 true 或者失败 false
@property (nonatomic, copy) void (^uploadFinished)(BOOL uploadSuccess);
@end
