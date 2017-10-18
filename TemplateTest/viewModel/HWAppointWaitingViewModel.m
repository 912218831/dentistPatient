//
//  HWAppointWaitingViewModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/21.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointWaitingViewModel.h"
#import "BaseWebViewModel.h"
@interface HWAppointWaitingViewModel()

@property(strong,nonatomic)NSString * appointId;
@property(strong,nonatomic,readwrite)HWAppointDetailModel * detailModel;

@end

@implementation HWAppointWaitingViewModel

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
        RACSignal * cancelSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [subscriber sendNext:@"请求中..."];
            [params setPObject:self.detailModel.appointId forKey:@"applyId"];
            NSURLSessionTask * task = [self post:kCancelAppoint params:params success:^(id response) {
                [subscriber sendNext:@"取消成功"];
            } failure:^(NSString * error) {
                [subscriber sendError:customRACError(@"取消失败")];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
                
            }];
        }];
        self.cancelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return cancelSignal;
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
