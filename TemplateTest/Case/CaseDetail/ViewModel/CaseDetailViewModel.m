//
//  CaseDetailViewModel.m
//  TemplateTest
//
//  Created by HW on 17/9/13.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "CaseDetailViewModel.h"

@implementation CaseDetailViewModel
@dynamic model;


- (void)bindViewWithSignal {
    [super bindViewWithSignal];
    
    @weakify(self);
    self.uploadImageSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [[RACObserve(self, waitUploadImage) filter:^BOOL(id value) {
            return value;
        }]subscribeNext:^(id x) {
            [subscriber sendNext:[RACSignal return:@1]];
            [[HWHTTPSessionManger shareHttpClient]HWPOSTImage:kUploadImage parameters:nil success:^(id responseObject) {
                [subscriber sendNext:[RACSignal empty]];
            } failure:^(NSString *error) {
                
                NSDictionary *imageItem = @{@"id": @"4",
                                            @"ImgUrl": @"http://img.taopic.com/uploads/allimg/140322/235058-1403220K93993.jpg"};
                CaseDetailImageModel *imageModel = [[CaseDetailImageModel alloc]initWithDictionary:imageItem error:nil];
                [self.model.images addObject:imageModel];
                [self caculateCellHeight];
                
                [subscriber sendNext:[RACSignal error:Error]];
            }];
        }];
        return nil;
    }];
}

- (void)initRequestSignal {
    @weakify(self);
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self post:kCaseDetail type:0 params:@{@"id":self.caseModel.Id} success:^(NSDictionary* response) {
            NSLog(@"%@",response);
            NSDictionary *data = [response dictionaryObjectForKey:@"data"];
            NSDictionary *info = [data dictionaryObjectForKey:@"info"];
            NSArray *image = [data arrayObjectForKey:@"image"];
            
            self.model = [[CaseDetailModel alloc]initWithDictionary:info error:nil];
            
            NSMutableArray *images = [NSMutableArray arrayWithCapacity:5];
            for (int i=0; i<5; i++) {
                NSDictionary *imageItem = @{@"id": @"4",
                                            @"ImgUrl": @"http://img.taopic.com/uploads/allimg/140322/235058-1403220K93993.jpg"};
                CaseDetailImageModel *imageModel = [[CaseDetailImageModel alloc]initWithDictionary:imageItem error:nil];
                [images addObject:imageModel];
            }
            self.model.images = images;
            [self caculateCellHeight];
            [subscriber sendNext:[RACSignal return:@1]];
        } failure:^(NSString *error) {
            [subscriber sendNext:[RACSignal error:Error]];
        }];
        return nil;
    }];
}

- (void)caculateCellHeight {
    NSArray *images = self.model.images;
    CGFloat height = kPhotoTitleY;
    NSInteger row = ceil(images.count/3.0);
    height += row*(kPhotoHeight+kPhotoSpaceY)+kPhotoSpaceY;
    self.imageCellHeight = height;
}

@end