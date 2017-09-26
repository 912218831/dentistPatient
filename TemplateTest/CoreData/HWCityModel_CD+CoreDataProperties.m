//
//  HWCityModel_CD+CoreDataProperties.m
//  
//
//  Created by 杨庆龙 on 2017/9/26.
//
//

#import "HWCityModel_CD+CoreDataProperties.h"

@implementation HWCityModel_CD (CoreDataProperties)

+ (NSFetchRequest<HWCityModel_CD *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"HWCityModel_CD"];
}

@dynamic name;
@dynamic cityId;
@dynamic pinyin;
@dynamic cityFirstChar;

@end
