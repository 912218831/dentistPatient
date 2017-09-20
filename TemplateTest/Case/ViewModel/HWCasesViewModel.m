//
//  HWCasesViewModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWCasesViewModel.h"

@interface HWCasesViewModel ()

@end
@implementation HWCasesViewModel
@dynamic requestSignal;

- (void)bindViewWithSignal {
    [super bindViewWithSignal];
}

- (void)initRequestSignal {
    @weakify(self);
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        FamilyMemberModel *model = [self.familyMember pObjectAtIndex:self.familyMemberIndex-1];
        [self post:kCaseList type:0 params:@{@"patientId":model.patientId} success:^(NSDictionary* response) {
            NSDictionary *data = [response dictionaryObjectForKey:@"data"];
            NSArray *list = [data arrayObjectForKey:@"list"];
            for (int i=0; i<list.count; i++) {
                CaseItemModel *model = [[CaseItemModel alloc]initWithDictionary:[list pObjectAtIndex:i] error:nil];
                [self.dataArray addObject:model];
            }
            [subscriber sendNext:[RACSignal return:@1]];
        } failure:^(NSString *error) {
            [subscriber sendNext:[RACSignal error:Error]];
        }];
        return nil;
    }];
    
    self.gainFamilyMember = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [self post:kFamilyMembers params:@{} success:^(NSDictionary* response) {
                NSArray *data = [response arrayObjectForKey:@"data"];
                NSMutableArray *familyMember = [NSMutableArray arrayWithCapacity:data.count];
                for (NSDictionary *item in data) {
                    FamilyMemberModel *model = [[FamilyMemberModel alloc]initWithDictionary:item error:nil];
                    [familyMember addObject:model];
                }
                self.familyMember = familyMember.copy;
                self.familyMemberIndex = 1;
                [subscriber sendNext:@1];
                [subscriber sendCompleted];
            } failure:^(NSString *error) {
                [subscriber sendError:Error];
            }];
            return nil;
        }];
    }];
}

@end
