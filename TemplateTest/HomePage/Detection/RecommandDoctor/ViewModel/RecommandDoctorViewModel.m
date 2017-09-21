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

- (instancetype)init {
    if (self = [super init]) {
        self.annotations = [NSMutableArray array];
    }
    return self;
}

- (void)initRequestSignal {
    @weakify(self);
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.dataArray removeAllObjects];
        [self post:kRecommandDoctor type:0 params:
             @{@"checkid":self.checkId,
               @"docLong":@(self.coordinate2D.longitude),
               @"docLat":@(self.coordinate2D.latitude),
               @"type":@""} success:^(NSDictionary *response) {
            NSDictionary *data = [response dictionaryObjectForKey:@"data"];
            NSArray *clinicList = [data arrayObjectForKey:@"clinicList"];
            [clinicList.rac_sequence foldLeftWithStart:@0 reduce:^id(id accumulator, NSDictionary *value) {
                RecommandDoctorModel *model = [MTLJSONAdapter modelOfClass:[RecommandDoctorModel class] fromJSONDictionary:value error:nil];
                [self.dataArray addObject:model];
                model.coordinated2D = CLLocationCoordinate2DMake(31.350536,121.564816);
                MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
                a1.coordinate = model.coordinated2D;
                a1.title      = [NSString stringWithFormat:@"anno: %@", accumulator];
                [self.annotations addObject:a1];
                return @([accumulator integerValue]+1);
            }];
            [subscriber sendNext:[RACSignal return:@1]];
        } failure:^(NSString *error) {
            [subscriber sendError:Error];
        }];
        return nil;
    }];
    RecommandDoctorModel *model = [RecommandDoctorModel new];
    [self.dataArray addObject:model];
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
