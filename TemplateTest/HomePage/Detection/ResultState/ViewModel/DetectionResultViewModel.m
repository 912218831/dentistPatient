//
//  DetectionViewModel.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DetectionResultViewModel.h"

@implementation DetectionResultViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)initRequestSignal {
    @weakify(self);
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self post:kDetectionResult type:0 params:@{} success:^(id response) {
            NSLog(@"%@",response);
            [subscriber sendNext:[RACSignal return:@1]];
        } failure:^(NSString *error) {
            NSLog(@"%@",error);
            self.detectionResultState = 1;
            for (int i=0; i<6; i++) {
                NSDictionary *dic = @{
                                      @"imageUrl": @"http://imgUrl",
                                      @"title": @"牙菌斑"
                                      };
                DetectionIssueItemModel *model = [[DetectionIssueItemModel alloc]initWithDictionary:dic error:nil];
                [self.dataArray addObject:model];
            }
            [subscriber sendNext:[RACSignal return:@0]];//[RACSignal error:Error
        }];
        return nil;
    }];
}

@end
