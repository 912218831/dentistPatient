//
//  HWCityModel_CD+CoreDataProperties.m
//  
//
//  Created by 杨庆龙 on 2017/10/11.
//
//

#import "HWCityModel_CD+CoreDataProperties.h"

@implementation HWCityModel_CD (CoreDataProperties)

+ (NSFetchRequest<HWCityModel_CD *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"HWCityModel_CD"];
}

@dynamic cityFirstChar;
@dynamic cityId;
@dynamic name;
@dynamic pinyin;
@dynamic pinyinHeader;

@end
