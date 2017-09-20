//
//  BaseModel.m
//  MVVMFrame
//
//  Created by lizhongqiang on 16/7/26.
//  Copyright © 2016年 lizhongqiang. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *mutableKeys = [[NSDictionary mtl_identityPropertyMapWithModel:self]mutableCopy];;
    if([mutableKeys objectForKey:@"Id"]){
        [mutableKeys setObject:@"id" forKey:@"Id"];
    }
    return mutableKeys;
}

- (NSDictionary *)JSONDictionaryFromModel {
    return [MTLJSONAdapter JSONDictionaryFromModel:self error:nil];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

@end
