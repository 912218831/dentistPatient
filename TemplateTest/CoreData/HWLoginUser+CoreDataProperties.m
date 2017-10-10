//
//  HWLoginUser+CoreDataProperties.m
//  
//
//  Created by 杨庆龙 on 2017/10/10.
//
//

#import "HWLoginUser+CoreDataProperties.h"

@implementation HWLoginUser (CoreDataProperties)

+ (NSFetchRequest<HWLoginUser *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"HWLoginUser"];
}

@dynamic key;
@dynamic userName;
@dynamic userPhone;
@dynamic userType;
@dynamic cityName;
@dynamic cityId;

@end
