//
//  BaseDataModel.m
//  MVVMFrame
//
//  Created by lizhongqiang on 16/7/26.
//  Copyright © 2016年 lizhongqiang. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark --- 请求方法

- (void)post:(NSString *)url type:(int)type params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    @weakify(self);
    [HWUserLogin currentUserLogin].userkey = @"333d4fab17bd2990248d3e6a9d3e772a";
    [self post:url params:params success:^(id json) {
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
}

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    
    [[HWHTTPSessionManger manager]HWPOST:url parameters:params success:^(id responese) {
        success(responese);
    } failure:^(NSString *code, NSString *error) {
        failure(error);
    }];
}

#pragma mark --- 网络数据处理方法
- (id)parserData_Dictionary:(NSDictionary *)jsonData {
    return nil;
}

- (void)bindViewWithSignal {}

@end
