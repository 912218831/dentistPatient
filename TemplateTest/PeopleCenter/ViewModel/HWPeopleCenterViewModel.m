//
//  HWPeopleCenterViewModel.m
//  TemplateTest
//
//  Created by HW on 17/9/10.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWPeopleCenterViewModel.h"
#import "BaseWebViewModel.h"
#import "SetPasswordViewModel.h"

@interface HWPeopleCenterViewModel ()

@end

@implementation HWPeopleCenterViewModel
@dynamic model;

- (void)bindViewWithSignal {
    @weakify(self);
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self post:kPersonCenterInfo type:0 params:@{} success:^(NSDictionary* response) {
            NSDictionary *data = [response dictionaryObjectForKey:@"data"];
            self.userName = [data stringObjectForKey:@"nickName"];
            self.userPhone = weakUserLogin.username;
            self.headImageUrl = [NSURL URLWithString:[data stringObjectForKey:@"headimage"]];
            self.model = [[HWPeopleCenterModel alloc]initWithDictionary:data error:nil];
            [subscriber sendCompleted];
        } failure:^(NSString *error) {
            
            [subscriber sendError:[NSError errorWithDomain:error code:404 userInfo:nil]];
        }];
        return nil;
    }];
    
    self.loginOutCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [[AppShare shareInstance] logout];
        return [RACSignal empty];
    }];
    
    self.scoreTouch = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSLog(@"积分");
        return [RACSignal empty];
    }];
    
    self.setPassword = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        // 跳转到设置密码页面
        SetPasswordViewModel *vm = [SetPasswordViewModel new];
        vm.phoneNumberStr = self.userPhone;
        [[ViewControllersRouter shareInstance]pushViewModel:vm animated:true];
        return [RACSignal empty];
    }];
    
    self.familyJump = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        BaseWebViewModel * model = [[BaseWebViewModel alloc] init];
        model.url = kFamily;
        model.title = @"我的家庭";
        [[ViewControllersRouter shareInstance] pushViewModel:model animated:YES];
        return [RACSignal empty];
    }];
}

@end
