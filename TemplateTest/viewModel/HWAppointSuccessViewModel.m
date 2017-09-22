//
//  HWAppointSuccessViewModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/21.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointSuccessViewModel.h"
#import "HWAppointCouponModel.h"
@interface HWAppointSuccessViewModel()

@property(strong,nonatomic)NSString * appointId;
@property(strong,nonatomic,readwrite)HWAppointDetailModel * detailModel;

@end

@implementation HWAppointSuccessViewModel
- (instancetype)initWithAppointId:(NSString *)appointId
{
    self = [super init];
    if (self) {
        self.appointId = appointId;
    }
    return self;
}

- (void)bindViewWithSignal
{
    [super bindViewWithSignal];
}

- (void)initRequestSignal
{
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setPObject:self.appointId forKey:@"applyId"];
        [self post:kAppointDetail params:params success:^(NSDictionary * response) {
            
            NSLog(@"%@",response);
            HWAppointDetailModel * model = [MTLJSONAdapter modelOfClass:[HWAppointDetailModel class] fromJSONDictionary:[[response objectForKey:@"data"] objectForKey:@"applyInfo"] error:nil];
            self.detailModel = model;
            self.coupons = [[[[response objectForKey:@"data"] objectForKey:@"coupon"] rac_sequence] foldLeftWithStart:[NSMutableArray array] reduce:^id(NSMutableArray * accumulator, NSDictionary * value) {
                HWAppointCouponModel * couponModel = [[HWAppointCouponModel alloc] initWithDictionary:value error:nil];
                [accumulator addObject:couponModel];
                return accumulator;
            }];
            [subscriber sendNext:response];
        } failure:^(NSString * error) {
            [subscriber sendError:customRACError(error)];
        }];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}


@end
