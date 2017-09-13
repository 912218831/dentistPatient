//
//  BaseDataModel.m
//  MVVMFrame
//
//  Created by lizhongqiang on 16/7/26.
//  Copyright © 2016年 lizhongqiang. All rights reserved.
//

#import "BaseViewModel.h"

@interface BaseViewModel ()
@property (nonatomic, strong) NSMutableDictionary *tasks;
@end

@implementation BaseViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.tasks = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark --- 请求方法

- (void)post:(NSString *)url type:(int)type params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    @weakify(self);
    [HWUserLogin currentUserLogin].userkey = @"333d4fab17bd2990248d3e6a9d3e772a";
    NSURLSessionDataTask *task = [self.tasks objectForKey:url];
    if (task.state != NSURLSessionTaskStateCompleted) {
        [task cancel];
    }
    task = [self post:url params:params success:^(id json) {
        @strongify(self);
        if (!self) {
            return;
        }
        success(json);
    } failure:^(NSString *error) {
        @strongify(self);
        if (!self) {
            return;
        }
        failure(error);
    }];
    self.active = false;
    [self.tasks setObject:task forKey:url];
}

- (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    
    NSURLSessionDataTask *task = [[HWHTTPSessionManger manager]HWPOST:url parameters:params success:^(id responese) {
        success(responese);
    } failure:^(NSString *code, NSString *error) {
        failure(error);
    }];
    return task;
}

- (void)bindViewWithSignal {
    [self initRequestSignal];
    self.requestSignal = [self forwardSignalWhileActive:self.requestSignal];
}

- (void)initRequestSignal {}

- (void )execute {
    self.active = true;
}

@end
