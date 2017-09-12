//
//  HWLoginCellViewModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/11.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWLoginCellViewModel.h"

@interface HWLoginCellViewModel()

@property(assign,nonatomic,readwrite)BOOL canReGain; //是否可以重新点击
@property(strong,nonatomic,readwrite)NSString * title;//倒计时按钮的标题

@end
@implementation HWLoginCellViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.canReGain = YES;
        self.title = @"验证码";
        @weakify(self);
        __block NSInteger count = 10;
        __block RACSignal * signal = [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] doNext:^(NSDate * _Nullable x) {
            @strongify(self);
            count--;
            self.title = [NSString stringWithFormat:@"%lds后从新获取",(long)count];

        }] map:^id _Nullable(NSDate * _Nullable value) {
            
            return count > 0 ? @(YES):@(NO);
        }];
        
        RACSignal * gainCodeSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            __block RACDisposable * dispose = [signal subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                if (![x integerValue]) {
                    self.canReGain = YES;
                    count = 10;
                    self.title = @"重新获取";
                    [dispose dispose];
                }
                else
                {
                    self.canReGain = NO;

                }
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSMutableDictionary * params = [NSMutableDictionary dictionary];
                [params setPObject:self.telphone forKey:@"mobile"];
//                [params setPObject:@"type" forKey:@"1"];
                [self post:kGetVerifyCode type:1 params:params success:^(id response) {
                    [subscriber sendNext:@"获取验证码成功"];
                } failure:^(NSString *error) {
                    [subscriber sendError:[NSError errorWithDomain:@"com.getLoginCode" code:100 userInfo:@{NSLocalizedDescriptionKey:error}]];
                }];
                [subscriber sendCompleted];
            });
            return nil;
        }];
        self.verifyCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return gainCodeSignal;
        }];

        
    }
    return self;
}


@end
