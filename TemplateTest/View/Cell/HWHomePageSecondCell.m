//
//  HWHomePageSecondCell.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/13.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWHomePageSecondCell.h"
@interface HWHomePageSecondCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation HWHomePageSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(HWHomePagePushItemModel *)model
{
    [self.headerImgV sd_setImageWithURL:[NSURL URLWithString:model.imageurl] placeholderImage:placeHoderImg];
    self.titleLab.text = model.title;
}

@end
