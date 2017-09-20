//
//  RecommandDoctorModel.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "RecommandDoctorModel.h"

@implementation RecommandDoctorModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *dic = (NSMutableDictionary*)[super JSONKeyPathsByPropertyKey];
    [dic setObject:@"description" forKey:@"descrip"];
    [dic setObject:@"long" forKey:@"longitude"];
    [dic setObject:@"lat" forKey:@"latitude"];
    return dic;
}
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"latitude"]) {
        self.coordinated2D = CLLocationCoordinate2DMake([value doubleValue], self.coordinated2D.longitude);
    } else if ([key isEqualToString:@"longitude"]) {
        self.coordinated2D = CLLocationCoordinate2DMake(self.coordinated2D.latitude, [value doubleValue]);
    } else {
        [super setValue:value forKey:key];
    }
}

@end
