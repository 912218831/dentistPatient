//
//  HWLoginUser+CoreDataProperties.h
//  
//
//  Created by 杨庆龙 on 2017/10/10.
//
//

#import "HWLoginUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface HWLoginUser (CoreDataProperties)

+ (NSFetchRequest<HWLoginUser *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *key;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *userPhone;
@property (nullable, nonatomic, copy) NSString *userType;
@property (nullable, nonatomic, copy) NSString *cityName;
@property (nullable, nonatomic, copy) NSString *cityId;

@end

NS_ASSUME_NONNULL_END
