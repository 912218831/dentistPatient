//
//  DoctorDetailViewModel.m
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DoctorDetailViewModel.h"

@implementation DoctorDetailViewModel

- (void)initRequestSignal {
    @weakify(self);
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self post:kRDoctorDetail type:0 params:@{@"dentistId":@"1"} success:^(NSDictionary *response) {
            NSDictionary *data = [response dictionaryObjectForKey:@"data"];
            NSDictionary *dentistInfo = [data dictionaryObjectForKey:@"dentistInfo"];
            NSArray *datelist = [data arrayObjectForKey:@"datelist"];
            DoctorDetailModel *model = [MTLJSONAdapter modelOfClass:[DoctorDetailModel class] fromJSONDictionary:dentistInfo error:nil];
            [self.dataArray addObject:model];
            NSMutableArray *dates = [NSMutableArray arrayWithCapacity:datelist.count];
            for (NSDictionary *time in datelist) {
                DoctorDetailTimeListModel *timeModel = [[DoctorDetailTimeListModel alloc]initWithDictionary:time error:nil];
                [dates addObject:timeModel];
            }
            [dates removeLastObject];
            [self.dataArray addObject:dates];
            
            self.timesHeight = ceil(dates.count/4.0)*kRate(45);
            [subscriber sendNext:[RACSignal return:@1]];
        } failure:^(NSString *error) {
            [subscriber sendError:Error];
        }];
        return nil;
    }];
}

@end
