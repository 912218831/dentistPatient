//
//  BaseListViewModel.m
//  MVVMFrame
//
//  Created by lizhongqiang on 16/7/28.
//  Copyright © 2016年 lizhongqiang. All rights reserved.
//

#import "BaseListViewModel.h"
#import "BaseModel.h"

@interface BaseListViewModel ()
@property (nonatomic, strong, readwrite) NSMutableArray *dataArray;
@end

@implementation BaseListViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)post:(NSString *)url type:(int)type params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    @weakify(self);
    NSMutableDictionary *middle = [NSMutableDictionary dictionaryWithCapacity:params.allKeys.count+1];
    [middle setValuesForKeysWithDictionary:params];
    [middle setObject:@(self.currentPage) forKey:@"page"];
    [super post:url type:type params:middle success:^(id response) {
        @strongify(self);
        if (self.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        NSDictionary *data = [response dictionaryObjectForKey:@"data"];
        NSDictionary *page = [data dictionaryObjectForKey:@"page"];
        NSString *totalpage = [page stringObjectForKey:@"totalpage"];
        self.isLastPage = totalpage.integerValue == self.currentPage;
        success(response);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

@end
