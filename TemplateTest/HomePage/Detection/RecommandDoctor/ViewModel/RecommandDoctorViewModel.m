//
//  RecommandDoctorViewModel.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "RecommandDoctorViewModel.h"
#import "RecommandDoctorModel.h"

@implementation RecommandDoctorViewModel

- (void)initRequestSignal {
    @weakify(self);
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self post:kRecommandDoctor type:0 params:@{} success:^(NSDictionary *response) {
            NSDictionary *data = [response dictionaryObjectForKey:@"data"];
            NSArray *clinicList = [data arrayObjectForKey:@"clinicList"];
            [clinicList.rac_sequence foldLeftWithStart:@YES reduce:^id(id accumulator, NSDictionary *value) {
                [self.dataArray addObject:[MTLJSONAdapter modelOfClass:[RecommandDoctorModel class] fromJSONDictionary:value error:nil]];
                return @([accumulator integerValue]+1);
            }];
            [subscriber sendNext:[RACSignal return:@1]];
        } failure:^(NSString *error) {
            [subscriber sendError:Error];
        }];
        return nil;
    }];
}

- (void)post:(NSString *)url type:(int)type params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    @weakify(self);
    [self post:url params:params success:^(id response) {
        @strongify(self);
        if (self.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        success(response);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

@end
