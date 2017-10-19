//
//  HWCasesViewModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWCasesViewModel.h"

@interface HWCasesViewModel ()
// 用于通知过来的
@property (nonatomic, copy) NSString *patientId;
@end
@implementation HWCasesViewModel
@dynamic requestSignal;

- (instancetype)init {
    if (self = [super init]) {
        @weakify(self);
        [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kRefreshCaseList object:nil]subscribeNext:^(NSNotification *x) {
            @strongify(self);
            self.patientId = x.object;
            if (self.familyMemberIndex) {
                [self.familyMember enumerateObjectsUsingBlock:^(FamilyMemberModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj.patientId isEqualToString:self.patientId]){
                        self.familyMemberIndex = idx + 1;
                        *stop = true;
                    }
                }];
                [self execute];
            }
        }];
    }
    return self;
}

- (void)bindViewWithSignal {
    [super bindViewWithSignal];
}

- (void)initRequestSignal {
    @weakify(self);
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        FamilyMemberModel *model = [self.familyMember pObjectAtIndex:self.familyMemberIndex-1];
        NSDictionary *param = nil;
        if (![model.patientId isEqualToString:@"-1"]&&model) {
            param = @{@"patientId":model.patientId};
        }
        [self post:kCaseList type:0 params:param success:^(NSDictionary* response) {
            NSDictionary *data = [response dictionaryObjectForKey:@"data"];
            NSArray *list = [data arrayObjectForKey:@"list"];
            if (1) {
                for (int i=0; i<list.count; i++) {
                    CaseItemModel *model = [[CaseItemModel alloc]initWithDictionary:[list pObjectAtIndex:i] error:nil];
                    [self.dataArray addObject:model];
                }
            } else {
                for (int i=0; i<10; i++) {
                    CaseItemModel *model = [[CaseItemModel alloc]initWithDictionary:@{} error:nil];
                    [self.dataArray addObject:model];
                }
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
                FamilyMemberModel *model = [[FamilyMemberModel alloc]init];
                model.patientId = @"-1";
                model.name = @"全部";
                [familyMember addObject:model];
                for (NSDictionary *item in data) {
                    FamilyMemberModel *model = [[FamilyMemberModel alloc]initWithDictionary:item error:nil];
                    [familyMember addObject:model];
                }
                self.familyMember = familyMember.copy;
                if (self.patientId.length) {
                    [self.familyMember enumerateObjectsUsingBlock:^(FamilyMemberModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if([obj.patientId isEqualToString:self.patientId]){
                            self.familyMemberIndex = idx + 1;
                            *stop = true;
                        }
                    }];
                } else {
                    self.familyMemberIndex = 1;
                }
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
