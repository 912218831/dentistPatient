//
//  DoctorDetailViewModel.m
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DoctorDetailViewModel.h"

@implementation DoctorDetailViewModel

- (NSString *)checkId {
    if (_checkId.length) {
        return _checkId;
    } else {
        return @"";
    }
}

- (void)initRequestSignal {
    @weakify(self);
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self post:kRDoctorDetail type:0 params:@{@"dentistId":self.doctorModel.dentistId} success:^(NSDictionary *response) {
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
            [self.dataArray addObject:dates];
            
            MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
            a1.coordinate = model.coordinated2D;
            //a1.coordinate = CLLocationCoordinate2DMake(31.350536, 121.564817);
            a1.title      = model.clinicName;
            self.annotation = a1;
            
            self.timesHeight = ceil(dates.count/4.0)*kRate(45);
            [subscriber sendNext:[RACSignal return:@1]];
        } failure:^(NSString *error) {
            [subscriber sendNext:[RACSignal error:Error]];
        }];
        return nil;
    }];
}

- (void)bindViewWithSignal {
    [super bindViewWithSignal];
    
    @weakify(self);
    self.orderSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        if (!self.selectDateIndexPath) {
            [[RACQueueScheduler mainThreadScheduler]schedule:^{
                [subscriber sendNext:[RACSignal error:[NSError errorWithDomain:@"请选择预约日期" code:404 userInfo:nil]]];
            }];
        } else {
            NSInteger index = self.selectDateIndexPath.row*4 + self.selectDateIndexPath.section;
            DoctorDetailModel *model = [self.dataArray firstObject];
            DoctorDetailTimeListModel *time = [[self.dataArray lastObject] pObjectAtIndex:index];
            [self post:kRDoctorOrder params:@{  @"checkId":self.checkId?:@"",
                                                @"dentistId":model.Id,
                                                @"expectedTime":time.date,
                                                @"amPm":time.amPm} success:^(id response) {
                                                    [subscriber sendNext:[RACSignal empty]];
                                                } failure:^(NSString *error) {
                                                    [subscriber sendNext:[RACSignal error:Error]];
                                                }];
        }
        return nil;
    }];
}

- (void)dealloc {
    
}

@end
