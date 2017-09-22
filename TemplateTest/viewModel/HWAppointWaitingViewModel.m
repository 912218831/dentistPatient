//
//  HWAppointWaitingViewModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/21.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointWaitingViewModel.h"
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
    }
    return self;
}

- (void)bindViewWithSignal
{
    [super bindViewWithSignal];
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
