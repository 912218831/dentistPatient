//
//  DoctorDetailModel.m
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DoctorDetailModel.h"

@implementation DoctorDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *dic = (NSMutableDictionary *)[super JSONKeyPathsByPropertyKey];
    dic[@"descrip"] = @"description";
    dic[@"lon"] = @"long";
    return dic;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"lat"]) {
        self.coordinated2D = CLLocationCoordinate2DMake([value doubleValue], self.coordinated2D.longitude);
    } else if ([key isEqualToString:@"lon"]) {
        self.coordinated2D = CLLocationCoordinate2DMake(self.coordinated2D.latitude, [value doubleValue]);
    } else {
        [super setValue:value forKey:key];
    }
}
@end