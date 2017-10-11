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
        self.currentPage = 1;
    }
    return self;
}

- (void)post:(NSString *)url type:(int)type params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    @weakify(self);
    NSMutableDictionary *middle = [NSMutableDictionary dictionaryWithCapacity:params.allKeys.count+1];
    [middle setValuesForKeysWithDictionary:params];
    [middle setObject:@(self.currentPage) forKey:@"page"];
    if (self.currentPage <= 0) {
        self.isLastPage = false;
    }
    [super post:url type:type params:middle success:^(id response) {
        @strongify(self);
        if (self.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        NSDictionary *data = [response dictionaryObjectForKey:@"data"];
        NSDictionary *page = [data dictionaryObjectForKey:@"page"];
        NSString *totalpage = [page stringObjectForKey:@"totalpage"];
        self.allPage = totalpage.integerValue;
        self.isLastPage = totalpage.integerValue == self.currentPage;
        if (self.currentPage == 3) {
            self.isLastPage = true;
        }
        success(response);
    } failure:^(NSString *error) {
        failure(error);
    }];
}

@end
