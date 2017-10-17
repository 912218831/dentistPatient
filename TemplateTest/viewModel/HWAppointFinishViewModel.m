//
//  HWAppointFinishViewModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/10/13.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointFinishViewModel.h"
#import "BaseWebViewModel.h"
@interface HWAppointFinishViewModel()
@property(strong,nonatomic)NSString * appointId;
@property(strong,nonatomic,readwrite)HWAppointDetailModel * detailModel;

@end
@implementation HWAppointFinishViewModel
- (instancetype)initWithAppointId:(NSString *)appointId
{
    self = [super init];
    if (self) {
        self.appointId = appointId;
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
        NSURLSessionTask * task = [self post:kAppointDetail params:params success:^(NSDictionary * response) {
            HWAppointDetailModel * model = [MTLJSONAdapter modelOfClass:[HWAppointDetailModel class] fromJSONDictionary:[[response objectForKey:@"data"] objectForKey:@"applyInfo"] error:nil];
            self.detailModel = model;
            [subscriber sendCompleted];
        } failure:^(NSString * error) {
            [subscriber sendError:customRACError(error)];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

@end
