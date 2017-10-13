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
        }]subscribeNext:^(UIImage *x) {
            [subscriber sendNext:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:@1];
                return nil;
            }]];
            NSData *imageData = UIImageJPEGRepresentation(x, 0.8);
            [self postImage:kDetectionUploadReports type:0 params:@{@"imageFile":imageData,@"checkId":self.model.Id,@"userkey":[HWUserLogin currentUserLogin].userkey} success:^(NSDictionary *response) {
#if 0
                NSDictionary *imageItem = [response dictionaryObjectForKey:@"data"];
                CaseDetailImageModel *imageModel = [[CaseDetailImageModel alloc]initWithDictionary:imageItem error:nil];
                [self.model.images addObject:imageModel];
                [self caculateCellHeight];
#endif
                [self execute];
                [subscriber sendNext:[RACSignal empty]];
            } failure:^(NSString *error) {
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
            NSArray *images = [data arrayObjectForKey:@"image"];
            
            self.model = [[CaseDetailModel alloc]initWithDictionary:info error:nil];
            
            NSMutableArray *mutableImages = [NSMutableArray arrayWithCapacity:images.count];
            for (int i=0; i<images.count; i++) {
                NSDictionary *imageItem = [images objectAtIndex:i];
                CaseDetailImageModel *imageModel = [[CaseDetailImageModel alloc]initWithDictionary:imageItem error:nil];
                [mutableImages addObject:imageModel];
            }
            self.model.images = mutableImages;
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
