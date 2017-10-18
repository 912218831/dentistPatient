//
//  HWAppointSuccessViewModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/21.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointSuccessViewModel.h"
#import "HWAppointCouponModel.h"
#import "BaseWebViewModel.h"
@interface HWAppointSuccessViewModel()

@property(strong,nonatomic)NSString * appointId;
@property(strong,nonatomic,readwrite)HWAppointDetailModel * detailModel;
@property(strong,nonatomic)NSString * payType;
@end

@implementation HWAppointSuccessViewModel
- (instancetype)initWithAppointId:(NSString *)appointId
{
    self = [super init];
    if (self) {
        self.appointId = appointId;
        @weakify(self);
        RACSignal * paySignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            if (self.sumMoney.length == 0) {
                [subscriber sendError:customRACError(@"请输入金额")];
            }
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [params setPObject:self.detailModel.checkId forKey:@"checkID"];
            [params setPObject:self.detailModel.appointId forKey:@"applyId"];
            [params setPObject:self.selectCoupontModel.couponId forKey:@"couponID"];
            [params setPObject:self.sumMoney forKey:@"totalAmount"];
            [params setPObject:self.payType forKey:@"payType"];
            NSURLSessionTask * task = [self post:kCreateOrder params:params success:^(id response) {
                NSDictionary * dataDic = [response objectForKey:@"data"];
                self.orderCode = [dataDic objectForKey:@"orderCode"];
                [subscriber sendNext:[dataDic objectForKey:@"payEncodeString"]];
            } failure:^(NSString * error) {
                [subscriber sendError:customRACError(error)];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }];
        self.payCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber * input) {
            @strongify(self);
            self.payType = @"ALI";
            return paySignal;
        }];
        self.payCommand.allowsConcurrentExecution = YES;
        
        self.answerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            //咨询
            BaseWebViewModel * model = [[BaseWebViewModel alloc] init];
            model.title = @"咨询";
            model.url = [NSString stringWithFormat:@"%@&checkId=%@",kAnswer,self.detailModel.checkId];
            [[ViewControllersRouter shareInstance] pushViewModel:model animated:YES];
            return [RACSignal empty];
        }];

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
        [subscriber sendNext:@"请求中..."];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setPObject:self.appointId forKey:@"applyId"];
        [self post:kAppointDetail params:params success:^(NSDictionary * response) {
            
//            NSLog(@"%@",response);
            HWAppointDetailModel * model = [MTLJSONAdapter modelOfClass:[HWAppointDetailModel class] fromJSONDictionary:[[response objectForKey:@"data"] objectForKey:@"applyInfo"] error:nil];
            self.detailModel = model;
            self.coupons = [[[[response objectForKey:@"data"] objectForKey:@"coupon"] rac_sequence] foldLeftWithStart:[NSMutableArray array] reduce:^id(NSMutableArray * accumulator, NSDictionary * value) {
                HWAppointCouponModel * couponModel = [[HWAppointCouponModel alloc] initWithDictionary:value error:nil];
                [accumulator addObject:couponModel];
                return accumulator;
            }];
//            [subscriber sendNext:response];
            [subscriber sendCompleted];
        } failure:^(NSString * error) {
            [subscriber sendError:customRACError(error)];
        }];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}


- (void)handleOrder{
    
    
}

@end
