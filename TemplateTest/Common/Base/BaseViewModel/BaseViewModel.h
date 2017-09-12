//
//  BaseDataModel.h
//  MVVMFrame
//
//  Created by lizhongqiang on 16/7/26.
//  Copyright © 2016年 lizhongqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "BaseViewController.h"
#import <ReactiveViewModel/ReactiveViewModel.h>

#define Error [NSError errorWithDomain:error code:404 userInfo:nil]

typedef  NS_ENUM(int, APIType) {
    UserLogin = 1,
    HomeList ,
    NewList  ,
    PersonalInfo ,
};

@class BaseViewController;
@interface BaseViewModel : RVMViewModel
@property (nonatomic, strong) RACSignal *requestSignal;

@property (nonatomic, copy, readwrite)   NSString     *url;
@property (nonatomic, copy, readwrite)   NSDictionary *params;
@property (nonatomic, copy, readwrite)   NSString     *title;
@property (nonatomic, copy, readwrite)   NSString     *rightImageName;
@property (nonatomic, copy, readwrite)   NSString     *leftImageName;
- (void)fetchRemoteServerData ;

- (void)bindModel:(NSDictionary *)response ;

- (void)bindViewWithSignal;

- (void)get:(NSString *)url type:(int)type params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSString *))failure;

- (void)post:(NSString *)url type:(int)type params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSString *))failure;

@end
