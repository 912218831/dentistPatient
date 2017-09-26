//
//  HWCityModel_CD+CoreDataProperties.h
//  
//
//  Created by 杨庆龙 on 2017/9/26.
//
//

#import "HWCityModel_CD+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface HWCityModel_CD (CoreDataProperties)

+ (NSFetchRequest<HWCityModel_CD *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *cityId;
@property (nullable, nonatomic, copy) NSString *pinyin;
@property (nullable, nonatomic, copy) NSString *cityFirstChar;

@end

NS_ASSUME_NONNULL_END
