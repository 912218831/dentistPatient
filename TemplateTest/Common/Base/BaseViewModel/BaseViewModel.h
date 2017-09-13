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

@interface BaseViewModel : RVMViewModel
/*子类初始化*/
@property (nonatomic, strong) RACSignal *requestSignal;
/*子类重写*/
- (void)initRequestSignal;
- (void)bindViewWithSignal;

- (void)post:(NSString *)url type:(int)type params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSString *))failure;

/*激活 active，调用请求*/
- (void)execute;
@end
