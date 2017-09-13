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
            self.model.images = [images copy];
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
    NSInteger row = images.count/3+1;
    height += row*(kPhotoHeight+(row-1)*kPhotoSpaceY);
    self.imageCellHeight = height;
}

@end
