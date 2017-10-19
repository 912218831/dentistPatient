//
//  HWDetectionSelectMemberViewModel.m
//  TemplateTest
//
//  Created by HW on 17/9/15.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWDetectionSelectMemberViewModel.h"
#import "DetectionCaptureViewModel.h"

@implementation HWDetectionSelectMemberViewModel



- (void)bindViewWithSignal {
    [super bindViewWithSignal];
    self.type = 1;
    
    RACSubject *subject = [RACSubject subject];
    
    @weakify(self);
    
    RACSignal *caseSiganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        FamilyMemberModel *model = [self.dataArray objectAtIndex:self.selectIndexPath.row];
        [self post:kDetectionCreateCase params:@{@"patientId":model.patientId,
                                                 @"checkType":@(self.type)
                                                 } success:^(NSDictionary *response) {
            NSDictionary *data = [response dictionaryObjectForKey:@"data"];
            [subscriber sendNext:[data stringObjectForKey:@"checkId"]];
            [subscriber sendCompleted];
        } failure:^(NSString *error) {
            [subscriber sendError:Error];
        }];
        return nil;
    }];
    
    self.detectActionBlock = ^{
        @strongify(self);
        [subject sendNext:[RACSignal return:@1]];
        [caseSiganl subscribeNext:^(NSString *x) {
            if (x.length) {
                FamilyMemberModel *model = [self.dataArray objectAtIndex:self.selectIndexPath.row];
                DetectionCaptureViewModel *viewModel = [DetectionCaptureViewModel new];
                viewModel.checkId = x;
                viewModel.model = model;
                [[ViewControllersRouter shareInstance]pushViewModel:viewModel animated:true];
            }
        }error:^(NSError *error) {
            [subject sendNext:[RACSignal error:error]];
        }completed:^{
            [subject sendNext:[RACSignal empty]];
        }];
    };
    
    self.createCaseSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subject subscribe:subscriber];
        return nil;
    }];
}

- (void)initRequestSignal {
    @weakify(self);
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self post:kFamilyMembers params:@{} success:^(NSDictionary *response) {
            NSArray *data = [response arrayObjectForKey:@"data"];
            for (NSDictionary *item in data) {
                FamilyMemberModel *model = [[FamilyMemberModel alloc]initWithDictionary:item error:nil];
                [self.dataArray addObject:model];
            }
            [subscriber sendNext:[RACSignal empty]];
        } failure:^(NSString *error) {
            [subscriber sendNext:[RACSignal return:Error]];
        }];
        return nil;
    }];
}

@end
