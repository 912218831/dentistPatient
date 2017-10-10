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
    [HWUserLogin currentUserLogin].userkey = @"333d4fab17bd2990248d3e6a9d3e772a";
    NSURLSessionDataTask *task = [[HWHTTPSessionManger manager]HWPOST:url parameters:params success:^(id responese) {
        success(responese);
    } failure:^(NSString *code, NSString *error) {
        failure(error);
    }];
    return task;
}

- (void)postImage:(NSString *)url type:(int)type params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    NSError* error = NULL;
    __block NSData *imageData = nil;
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSData class]]) {
            imageData = obj;
            *stop = true;
        }
    }];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[kUrlBase stringByAppendingString:url] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"imageFile" fileName:@".jpg" mimeType:@"multipart/form-data"];
    } error:&error];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    //, @"text/json", @"text/javascript", @"text/html", @"text/plain"
    serializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",nil];
    //manager.responseSerializer = serializer;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"进度=%@",uploadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id responseObject, NSError * _Nullable error) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
            failure(str);
            return ;
        }
        if (error) {
            failure(error.description);
        } else {
            BOOL state = [[responseObject stringObjectForKey:@"statue"]boolValue];
            if (state) {
                NSString *detail = [responseObject stringObjectForKey:@"detail"];
                failure(detail);
            } else {
                success(responseObject);
            }
        }
    }];
    [uploadTask resume];
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
