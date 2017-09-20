//
//  DetectionViewModel.m
//  TemplateTest
//
//  Created by HW on 17/9/15.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DetectionCaptureViewModel.h"

@implementation DetectionCaptureViewModel

- (void)bindViewWithSignal {
    [super bindViewWithSignal];
}

- (void)initRequestSignal {
    @weakify(self);
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self post:kDetectionCapturePhotos type:0 params:@{} success:^(id response) {
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
