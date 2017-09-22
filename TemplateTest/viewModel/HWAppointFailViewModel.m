//
//  HWAppointFailViewModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/21.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointFailViewModel.h"
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
    }
    return self;
}

- (void)bindViewWithSignal
{
    [super bindViewWithSignal];
    self.acceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       //采纳医生建议
        NSLog(@"采纳医生建议");
        return [RACSignal empty];
    }];
    
    self.rejectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"返回重新预约");
        return [RACSignal empty];
    }];
    
    self.cancelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       
        NSLog(@"取消预约");
        return [RACSignal empty];
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
