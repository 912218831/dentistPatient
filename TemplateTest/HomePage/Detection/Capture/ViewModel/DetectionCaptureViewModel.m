//
//  DetectionViewModel.m
//  TemplateTest
//
//  Created by HW on 17/9/15.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DetectionCaptureViewModel.h"
@interface DetectionCaptureViewModel ()
@property (nonatomic, strong) RACSubject *hotSignal;
@end

@implementation DetectionCaptureViewModel
@dynamic model;

- (void)bindViewWithSignal {
    [super bindViewWithSignal];
    
    @weakify(self);
    self.deletePhotoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        DetectionCaptureModel *model = [self.dataArray objectAtIndex:[input integerValue]];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            if (model.Id) {
                [self post:kDetectionDeletePhoto params:@{@"checkId":self.checkId,
                                                          @"imgId":model.Id==nil?@"":model.Id} success:^(id response) {
                                                              [subscriber sendNext:[RACSignal return:input]];
                                                              [subscriber sendCompleted];
                                                          } failure:^(NSString *error) {
                                                              [subscriber sendNext:[RACSignal error:Error]];
                                                              [subscriber sendCompleted];
                                                          }];
            }
            return nil;
        }];
    }];
}

- (void)initRequestSignal {
    self.hotSignal = [RACSubject subject];
    @weakify(self);
    [self.requestSignal and];
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.hotSignal subscribeNext:^(id x) {
            [subscriber sendNext:[RACSignal return:@1]];
        } error:^(NSError *error) {
            [subscriber sendNext:[RACSignal error:error]];
        }];
        [subscriber sendNext:[RACSignal return:@1]];
//        [self post:kDetectionCapturePhotos type:0 params:@{@"checkid":self.checkId} success:^(NSDictionary *response) {
//            NSArray *data = [response arrayObjectForKey:@"data"];
//            for (int i=0; i<data.count; i++) {
//                NSDictionary *dic = [data objectAtIndex:i];
//                DetectionCaptureModel *model = [[DetectionCaptureModel alloc]initWithDictionary:dic error:nil];
//                [self.dataArray addObject:model];
//            }
//            [subscriber sendNext:[RACSignal return:@1]];
//        } failure:^(NSString *error) {
//            [subscriber sendNext:[RACSignal error:Error]];
//        }];
        return nil;
    }];
}

- (void)takePhotoSuccess:(UIImage *)image {
    if (image) {
        DetectionCaptureModel *model = [[DetectionCaptureModel alloc]init];
        model.image = image;
        model.needUpload = true;
        [self.dataArray addObject:model];
        [self.hotSignal sendNext:@"ADD"];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        @weakify(model,self);
        [[HWHTTPSessionManger manager]HWPOSTImage:kDetectionUploadImage parameters:@{@"imageFile":imageData,@"checkId":self.checkId} success:^(id responseObject) {
            @strongify(model);
            if (model.uploadFinished) {
                NSDictionary *data = [responseObject dictionaryObjectForKey:@"data"];
                model.Id =  [data stringObjectForKey:@"imgId"];
                model.needUpload = false;
                model.uploadSuccess = true;
                model.uploadFinished(true);
            }
        } failure:^(NSString *error) {
            @strongify(model,self);
            if (model.uploadFinished) {
                model.needUpload = false;
                model.uploadSuccess = true;
                model.uploadFinished(false);
                
                [self.dataArray removeObject:model];
                [self.hotSignal sendError:Error];
            }
        }];
    }
}

- (BOOL)canNextStep {
    __block BOOL existNeedUpload = false;
    [self.dataArray enumerateObjectsUsingBlock:^(DetectionCaptureModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.needUpload) {
            existNeedUpload = true;
            *stop = true;
        }
    }];
    return self.dataArray.count?!existNeedUpload:false;
}

@end
