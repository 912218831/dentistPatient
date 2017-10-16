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
#import "HWAppointFinishViewModel.h"

@interface HWAppointmentViewModel()
@property(nonatomic,strong)NSArray * dataArr;
@end

@implementation HWAppointmentViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentPage = @"1";
    }
    return self;
}

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
        else if([model.state isEqualToString:@"4"])
        {
            //等待病人确定
            HWAppointFailViewModel * failViewModel = [[HWAppointFailViewModel alloc] initWithAppointId:model.appointId];
            @weakify(self);
            [failViewModel.cancelCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
                @strongify(self);
                self.isNeedRefresh = YES;
            }];
            
            [failViewModel.acceptCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
                @strongify(self);
                self.isNeedRefresh = YES;
            }];
            
            [[ViewControllersRouter shareInstance] pushViewModel:failViewModel animated:YES];

        }
        else if([model.state isEqualToString:@"5"])
        {
            //完成
            HWAppointFinishViewModel * finishViewModel = [[HWAppointFinishViewModel alloc] initWithAppointId:model.appointId];
            [[ViewControllersRouter shareInstance] pushViewModel:finishViewModel animated:YES];
            
        }
        else
        {
            
        }
        return [RACSignal empty];
    }];
}

- (void)initRequestSignal
{
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"请求中..."];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setPObject:kPageCount forKey:@"pageSize"];
        [params setPObject:self.currentPage forKey:@"page"];
        NSURLSessionTask * task = [self post:kAppointList params:params success:^(id response) {
            NSDictionary * dataDic = [response objectForKey:@"data"];
            NSArray * tempDataArr = [[[dataDic objectForKey:@"applyList"] rac_sequence] foldLeftWithStart:[NSMutableArray array] reduce:^id(NSMutableArray * accumulator, NSDictionary * value) {
                HWAppointListModel * model = [MTLJSONAdapter modelOfClass:[HWAppointListModel class] fromJSONDictionary:value error:nil];
                [accumulator addObject:model];
                return accumulator;
            }];
            if(self.currentPage.integerValue == 1)
            {
                //第一页
                self.dataArr = [tempDataArr copy];
            }
            else
            {
                NSMutableArray * tempMutArr = [NSMutableArray arrayWithArray:self.dataArr];
                [tempMutArr addObjectsFromArray:tempDataArr];
                if (tempDataArr.count < kPageCount.integerValue) {
                    //没有下一页
                    self.isLastPage = YES;
                }
                else
                {
                    //有下一页
                    self.isLastPage = NO;
                    self.currentPage = [NSString stringWithFormat:@"%ld",self.currentPage.integerValue+1];
                }

            }
            [subscriber sendNext:self.dataArr];
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
