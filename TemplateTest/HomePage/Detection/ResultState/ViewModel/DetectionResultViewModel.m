//
//  DetectionViewModel.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DetectionResultViewModel.h"
#import "RecommandDoctorViewModel.h"

#define kDetectionResultViewModelDebug 1

@implementation DetectionResultViewModel
@dynamic model;

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
        [self post:kDetectionResult type:0 params:@{@"checkId":self.checkId} success:^(id response) {
            NSLog(@"%@",response);
            for (int i=0; i<6; i++) {
                NSDictionary *dic = @{
                                      @"imageUrl": @"http://imgUrl",
                                      @"title": @"牙菌斑"
                                      };
                DetectionIssueItemModel *model = [[DetectionIssueItemModel alloc]initWithDictionary:dic error:nil];
                [self.dataArray addObject:model];
            }
            self.detectionResultState = 0;
            [subscriber sendNext:[RACSignal return:@0]];
        } failure:^(NSString *error) {
            NSLog(@"%@",error);
#if kDetectionResultViewModelDebug
            for (int i=0; i<6; i++) {
                NSDictionary *dic = @{
                                      @"imageUrl": @"http://imgUrl",
                                      @"title": @"牙菌斑"
                                      };
                DetectionIssueItemModel *model = [[DetectionIssueItemModel alloc]initWithDictionary:dic error:nil];
                [self.dataArray addObject:model];
            }
            [subscriber sendNext:[RACSignal return:@0]];
#else
            NSLog(@"无问题");
            self.detectionResultState = 1;
            [subscriber sendNext:[RACSignal return:@1]];
#endif
        }];
        return nil;
    }];
    
    
}

- (void)setSeeDoctorSignal:(RACSignal *)seeDoctorSignal {
    @weakify(self);
    [seeDoctorSignal subscribeNext:^(id x) {
        @strongify(self);
        RecommandDoctorViewModel *vm = [RecommandDoctorViewModel new];
        vm.checkId = self.checkId;
        vm.needSearchBar = false;
        [[ViewControllersRouter shareInstance]pushViewModel:vm animated:true];
    }];
}

- (void)setNotSendSignal:(RACSignal *)notSendSignal {
    @weakify(self);
    [notSendSignal subscribeNext:^(id x) {
        @strongify(self);
        [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshCaseList object:self.model.patientId];
        [[ViewControllersRouter shareInstance]popToRootViewModelAnimated:false];
        [(HWTabBarViewController*)SHARED_APP_DELEGATE.viewController setSelectedIndex:1];
    }];
}

@end
