//
//  HWHomePageViewModel.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWHomePageViewModel.h"
#import "HWHomePageBannerModel.h"
#import "HWHomePagePushItemModel.h"
#import "HWHomePageLastRecordModel.h"
#import "HWDetectionSelectMemberViewModel.h"
#import "HWCitySelectViewModel.h"
#import "BaseWebViewModel.h"
#import "RecommandDoctorViewModel.h"
#import "CaseDetailViewModel.h"
@implementation HWHomePageViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

- (void)bindViewWithSignal
{
    [super bindViewWithSignal];
    self.selectCityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        HWCitySelectViewModel * selectCityModel = [HWCitySelectViewModel new];
        [[ViewControllersRouter shareInstance] pushViewModel:selectCityModel animated:YES];
        return [RACSignal empty];
    }];
    self.searchDocCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RecommandDoctorViewModel * viewModel = [[RecommandDoctorViewModel alloc] init];
        viewModel.needSearchBar = YES;
        [[ViewControllersRouter shareInstance] pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    self.bannerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber * index) {
       
        NSLog(@"%@",index);
        HWHomePageBannerModel * bannerModel = [self.bannerModels pObjectAtIndex:index.integerValue];
        BaseWebViewModel * webViewModel = [BaseWebViewModel new];
        webViewModel.url = bannerModel.targetUrl;
        webViewModel.title = bannerModel.title;
        [[ViewControllersRouter shareInstance] pushViewModel:webViewModel animated:YES];
        return [RACSignal empty];
    }];
    
    self.pushItemCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath * indexPath) {
       
        NSLog(@"%@",indexPath);
        if (indexPath.section == 1) {
            HWHomePagePushItemModel * model = [self.pushitems pObjectAtIndex:indexPath.row];
            BaseWebViewModel * webViewModel = [BaseWebViewModel new];
            webViewModel.url = model.targetUrl;
            webViewModel.title = model.title;
            [[ViewControllersRouter shareInstance] pushViewModel:webViewModel animated:YES];

        }
        else if(indexPath.section == 2)
        {
            HWHomePageLastRecordModel * model = [self.lastRecords pObjectAtIndex:indexPath.row];
            CaseDetailViewModel * caseDetailVM = [[CaseDetailViewModel alloc] initWithCaseId:model.recodeId];
            [[ViewControllersRouter shareInstance] pushViewModel:caseDetailVM animated:YES];
        }
        else
        {
            
        }
        return [RACSignal empty];
    }];
    
    self.funcBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber * index) {
        NSInteger i = index.integerValue;
        switch (i) {
            case 0:
            {
                NSLog(@"我的家庭");
                BaseWebViewModel * model = [[BaseWebViewModel alloc] init];
                model.url = kFamily;
                model.title = @"我的家庭";
                [[ViewControllersRouter shareInstance] pushViewModel:model animated:YES];
            }
                break;
            case 1:
            {
                NSLog(@"百科");
                BaseWebViewModel * model = [[BaseWebViewModel alloc] init];
                model.url = kBaiKe;
                model.title = @"口腔百科";
                [[ViewControllersRouter shareInstance] pushViewModel:model animated:YES];

            }
                break;
            case 2:
            {
                NSLog(@"检测");
                [[ViewControllersRouter shareInstance]pushViewModel:[HWDetectionSelectMemberViewModel new] animated:true];
            }
                break;
            case 3:
            {
                NSLog(@"记录");
                BaseWebViewModel * model = [[BaseWebViewModel alloc] init];
                model.url = kHistory;
                model.title = @"记录";
                [[ViewControllersRouter shareInstance] pushViewModel:model animated:YES];

            }
                break;
            default:
                break;
        }
        return [RACSignal empty];
    }];
}

- (void)initRequestSignal
{
    self.requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setPObject:[HWUserLogin currentUserLogin].cityName forKey:@"cityname"];
        [params setPObject:[HWUserLogin currentUserLogin].cityId forKey:@"cityCode"];
        NSDictionary * maps = @{@"topImages":@"HWHomePageBannerModel",@"pushitem":@"HWHomePagePushItemModel",@"lastRecord":@"HWHomePageLastRecordModel"};
        __block NSInteger index = 0;
        @weakify(self);
        NSURLSessionDataTask * task = [self post:kHomePage params:params success:^(NSDictionary * response) {
            NSDictionary * dataDic = [response objectForKey:@"data"];
            [[[[dataDic rac_sequence] reduceEach:^(NSString * key,NSArray * value){
                RACTuple * t = RACTuplePack(key,[[value rac_sequence] foldLeftWithStart:[NSMutableArray array] reduce:^id(NSMutableArray * accumulator, NSDictionary * dic) {
                    BaseModel * model = [MTLJSONAdapter modelOfClass:[NSClassFromString(maps[key]) class] fromJSONDictionary:dic error:nil];
                    [accumulator addObject:model];
                    return accumulator;
                }],@(index));
                index++;
                return t;
            }] signal] subscribeNext:^(RACTuple * t) {
                @strongify(self);
                if ([t.first isEqualToString:@"topImages"]) {
                    self.bannerModels = [NSMutableArray arrayWithArray:t.second];
                }
                else if([t.first isEqualToString:@"pushitem"])
                {
                    self.pushitems = [NSMutableArray arrayWithArray:t.second];

                }
                else if([t.first isEqualToString:@"lastRecord"])
                {
                    self.lastRecords = [NSMutableArray arrayWithArray:t.second];
                }
                else
                {
                    return;
                }
                if ([(NSNumber*)t.third integerValue] == 2) {
                    
                    [subscriber sendNext:response];

                }
            }];
        } failure:^(NSString *error) {
            [subscriber sendError:customRACError(error)];
            
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

@end
