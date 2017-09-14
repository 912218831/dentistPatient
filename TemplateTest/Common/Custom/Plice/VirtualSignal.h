//
//  VirtualSignal.h
//  TemplateTest
//
//  Created by HW on 17/9/14.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VirtualSignal;
@protocol VirtualSignalProtocol <NSObject>

+ (VirtualSignal *)createSignal:(void (^)(id<RACSubscriber> subscriber))didSubscribe;

- (void)subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock;

@end

@interface VirtualSignal : NSObject <VirtualSignalProtocol>

@end


@interface VirtualSubscriber : NSObject <RACSubscriber>
@property (nonatomic, copy) void (^nextBlock)(id);
@property (nonatomic, copy) void (^errorBlock)(NSError *);
@property (nonatomic, copy) void (^completedBlock)(void);
@end
