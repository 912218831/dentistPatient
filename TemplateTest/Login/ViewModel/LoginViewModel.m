//
//  LoginViewModel.m
//  TemplateTest
//
//  Created by HW on 17/9/2.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "LoginViewModel.h"

#import <NetworkExtension/NetworkExtension.h>  

@interface LoginViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *loginCommand;
@end

@implementation LoginViewModel
@synthesize gainCodeChannel;

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)bindViewWithSignal {
    
    [self.usernameSignal subscribeNext:^(id x) {
        
    }];
    [self.vertifyCodeSignal subscribeNext:^(id x) {
       
    }];
    
    @weakify(self);
    self.gainCodeChannel = [RACChannel new];
    [gainCodeChannel.followingTerminal subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [self post:kLoginGainVertifyCode type:0 params:@{} success:^(id response) {
            [self.gainCodeChannel.followingTerminal sendNext:response];
        } failure:^(NSString *error) {
            [self.gainCodeChannel.followingTerminal sendNext:error];
        }];
    }];
    
    self.loginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            if (1) {//weakUserLogin.userPassword.length && weakUserLogin.username.length
                [self post:kLoginApp type:0 params:@{}
                   success:^(id response) {
                       [subscriber sendNext:response];
                       [subscriber sendCompleted];
                       //[HWCoreDataManager saveUserInfo];
                   } failure:^(NSString *error) {
                       [subscriber sendError:[NSError errorWithDomain:error code:404 userInfo:nil]];
                   }];
            }
            return nil;
        }];
    }];
}


+ (void)getWifiList {
    
    if (![[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {return;}
    dispatch_queue_t queue = dispatch_queue_create("com.leopardpan.HotspotHelper", 0);
    [NEHotspotHelper registerWithOptions:nil queue:dispatch_get_main_queue() handler: ^(NEHotspotHelperCommand * cmd) {
        if(cmd.commandType == kNEHotspotHelperCommandTypeFilterScanList) {
            for (NEHotspotNetwork* network  in cmd.networkList) {
                NSLog(@"network.SSID = %@",network.SSID);
            }
        }
    }];
}


@end
