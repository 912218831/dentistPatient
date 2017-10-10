//
//  HWAppointFailViewModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/21.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointFailViewModel.h"
#import "BaseWebViewModel.h"
#import "RecommandDoctorViewModel.h"
@interface HWAppointFailViewModel()

@property(strong,nonatomic,readwrite)HWAppointDetailModel * detailModel;
@property(strong,nonatomic)NSString * appointId;
@end

@implementation HWAppointFailViewModel
@dynamic model;

- (instancetype)initWithAppointId:(NSString *)appointId
{
    self = [super init];
    if (self) {
        self.appointId = appointId;
        RACSignal * acceptSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [subscriber sendNext:@"请求中..."];
            [params setPObject:self.detailModel.appointId forKey:@"applyId"];
            NSURLSessionTask * task = [self post:kAccecptAppoint params:params success:^(id response) {
//                [subscriber sendNext:@"采纳医生建议"];
                [subscriber sendCompleted];
                [[ViewControllersRouter shareInstance] popViewModelAnimated:YES];
            } failure:^(NSString * error) {
                [subscriber sendError:customRACError(@"采纳医生建议失败")];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }];
        
        self.acceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            //采纳医生建议
            
            return acceptSignal;
        }];
        
        
        RACSignal * rejectSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"返回重新预约"];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
        
        self.rejectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            RecommandDoctorViewModel * model = [[RecommandDoctorViewModel alloc] init];
            model.needSearchBar = YES;
            return rejectSignal;
        }];
        
        RACSignal * cancelSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [subscriber sendNext:@"请求中..."];
            [params setPObject:self.detailModel.appointId forKey:@"applyId"];
            NSURLSessionTask * task = [self post:kCancelAppoint params:params success:^(id response) {
//                [subscriber sendNext:@"取消预约"];
                [subscriber sendCompleted];
                [[ViewControllersRouter shareInstance] popViewModelAnimated:YES];
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
        
        self.answerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            //咨询
            BaseWebViewModel * model = [[BaseWebViewModel alloc] init];
            model.title = @"咨询";
            model.url = kAnswer;
            [[ViewControllersRouter shareInstance] pushViewModel:model animated:YES];
            return [RACSignal empty];
        }];
        
    }
    return self;
}

- (void)bindViewWithSignal
{
    [super bindViewWithSignal];
    
    [self.cancelCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"fff");
        
    }];
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
            [subscriber sendNext:response];
        } failure:^(NSString * error) {
            [subscriber sendError:customRACError(error)];
        }];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

@end
