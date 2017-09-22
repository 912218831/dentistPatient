//
//  DetectionViewModel.m
//  TemplateTest
//
//  Created by HW on 17/9/15.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DetectionCaptureViewModel.h"
@interface DetectionCaptureViewModel ()

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
            
            [self post:kDetectionDeletePhoto params:@{@"checkId":self.checkId,
                                                   @"imgId":model.Id} success:^(id response) {
                 [subscriber sendNext:[RACSignal return:input]];
                  [subscriber sendCompleted];
            } failure:^(NSString *error) {
                [subscriber sendNext:[RACSignal error:Error]];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
}

- (void)initRequestSignal {
    @weakify(self);
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self post:kDetectionCapturePhotos type:0 params:@{@"checkid":self.checkId} success:^(id response) {
            for (int i=0; i<5; i++) {
                NSDictionary *dic = @{
                    @"id": @"11",
                    @"imgUrl": @"http://img.taopic.com/uploads/allimg/140322/235058-1403220K93993.jpg",
                    @"machinereturn": @"P01"
                    };
                DetectionCaptureModel *model = [[DetectionCaptureModel alloc]initWithDictionary:dic error:nil];
                [self.dataArray addObject:model];
            }
            [subscriber sendNext:[RACSignal return:@1]];
        } failure:^(NSString *error) {
            [subscriber sendNext:[RACSignal error:Error]];
        }];
        return nil;
    }];
}

@end
