//
//  VirtualSignal.m
//  TemplateTest
//
//  Created by HW on 17/9/14.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "VirtualSignal.h"

@interface VirtualSignal ()
@property (nonatomic, copy) void (^didSubscribe)(id<RACSubscriber>);
@end

@implementation VirtualSignal

+ (VirtualSignal *)createSignal:(void (^)(id<RACSubscriber>))didSubscribe {
    VirtualSignal *signal = [VirtualSignal new];
    signal.didSubscribe = didSubscribe;
    return signal;
}

- (void)subscribeNext:(void (^)(id))nextBlock error:(void (^)(NSError *))errorBlock completed:(void (^)(void))completedBlock {
    VirtualSubscriber *subject = [VirtualSubscriber new];
    subject.nextBlock = nextBlock;
    subject.errorBlock = errorBlock;
    subject.completedBlock = completedBlock;
    self.didSubscribe(subject);
}

@end

@interface VirtualSubscriber ()

@end

@implementation VirtualSubscriber

- (void)sendNext:(id)value {
    if (self.nextBlock) {
        self.nextBlock(value);
    }
}

- (void)sendError:(NSError *)error {
    if (self.errorBlock) {
        self.errorBlock(error);
    }
    
}

- (void)sendCompleted {
    if (self.completedBlock) {
        self.completedBlock();
    }
}

- (void)didSubscribeWithDisposable:(RACCompoundDisposable *)disposable {
    
}

@end
