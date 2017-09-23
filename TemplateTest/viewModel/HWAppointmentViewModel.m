//
//  HWAppointmentViewModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointmentViewModel.h"
#import "HWAppointListModel.h"
#import "HWAppointFailViewModel.h"
#import "HWAppointSuccessViewModel.h"
#import "HWAppointWaitingViewModel.h"
@implementation HWAppointmentViewModel

- (void)bindViewWithSignal
{
    [super bindViewWithSignal];
    self.itemClickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(HWAppointListModel* model) {
        
        if ([model.state isEqualToString:@"1"]) {
            //等待医生确认
            HWAppointWaitingViewModel * successViewModel = [[HWAppointWaitingViewModel alloc] initWithAppointId:model.appointId];
            [[ViewControllersRouter shareInstance] pushViewModel:successViewModel animated:YES];

        }
        else if([model.state isEqualToString:@"3"])
        {
            //预约成功
            HWAppointSuccessViewModel * successViewModel = [[HWAppointSuccessViewModel alloc] initWithAppointId:model.appointId];
            [[ViewControllersRouter shareInstance] pushViewModel:successViewModel animated:YES];
        }
        else
        {
            //失败
            HWAppointFailViewModel * failViewModel = [[HWAppointFailViewModel alloc] initWithAppointId:model.appointId];
            @weakify(self);
            [failViewModel.cancelCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
                @strongify(self);
                self.isNeedRefresh = YES;
            }];
            [[ViewControllersRouter shareInstance] pushViewModel:failViewModel animated:YES];

        }
        return [RACSignal empty];
    }];
}

- (void)initRequestSignal
{
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"请求中..."];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        NSURLSessionTask * task = [self post:kAppointList params:params success:^(id response) {
            NSDictionary * dataDic = [response objectForKey:@"data"];
            NSArray * dataArr = [[[dataDic objectForKey:@"applyList"] rac_sequence] foldLeftWithStart:[NSMutableArray array] reduce:^id(NSMutableArray * accumulator, NSDictionary * value) {
                HWAppointListModel * model = [MTLJSONAdapter modelOfClass:[HWAppointListModel class] fromJSONDictionary:value error:nil];
                [accumulator addObject:model];
                return accumulator;
            }];
            [subscriber sendNext:dataArr];
//            [subscriber sendCompleted];
        } failure:^(NSString *error) {
           
            [subscriber sendError:customRACError(error)];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

@end
