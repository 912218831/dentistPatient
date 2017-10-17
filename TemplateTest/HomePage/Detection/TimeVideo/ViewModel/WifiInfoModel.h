//
//  WifiInfoModel.h
//  HKSDKDemo
//
//  Created by 杨庆龙 on 2017/9/27.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WifiInfoModel : NSObject<NSCopying,NSMutableCopying>
@property(strong,nonatomic)NSString * sid;
@property(strong,nonatomic)NSString * entype;
@property(strong,nonatomic)NSString * satype;
@property(strong,nonatomic)NSString * macInfo;
- (instancetype)initWithInfo:(NSString *)info;

@end
