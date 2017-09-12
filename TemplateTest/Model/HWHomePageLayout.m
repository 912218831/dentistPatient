//
//  HWHomePageLayout.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWHomePageLayout.h"

@implementation HWHomePageLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.headerReferenceSize = CGSizeMake(kScreenWidth, kRate(315));
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.itemSize = CGSizeMake(168, 105);
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 25;
    }
    return self;
}

@end
