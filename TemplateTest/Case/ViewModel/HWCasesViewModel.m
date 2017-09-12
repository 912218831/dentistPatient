//
//  HWCasesViewModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWCasesViewModel.h"

@implementation HWCasesViewModel

- (void)bindViewWithSignal {
    
    @weakify(self);
    RACSignal *subject = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        self.active = false;
        [self post:kCaseList type:0 params:@{} success:^(NSDictionary* response) {
            NSDictionary *data = [response dictionaryObjectForKey:@"data"];
            NSArray *list = [data arrayObjectForKey:@"list"];
            for (int i=0; i<list.count; i++) {
                CaseItemModel *model = [[CaseItemModel alloc]initWithDictionary:[list pObjectAtIndex:i] error:nil];
                [self.dataArray addObject:model];
            }
            [subscriber sendNext:@1];
        } failure:^(NSString *error) {
            [subscriber sendError:Error];
        }];
        return nil;
    }];
    self.requestSignal = [self forwardSignalWhileActive:subject];
}

@end
