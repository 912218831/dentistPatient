//
//  HWHomePageHeader.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWHomePageHeader : UICollectionReusableView

@property(strong,nonatomic)RACCommand * itemClickCommand;
@property(strong,nonatomic)NSArray * dataArr;
@end
