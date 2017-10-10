//
//  HWHomePageLastRecordCell.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/10/9.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWHomePageLastRecordCell.h"

@interface HWHomePageLastRecordCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *recodeName;
@property (weak, nonatomic) IBOutlet UILabel *recordDescription;
@property (weak, nonatomic) IBOutlet UILabel *recordTime;


@end

@implementation HWHomePageLastRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(HWHomePageLastRecordModel *)model
{
    _model = model;
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:model.thumbnailUrl] placeholderImage:placeHoderImg];
    self.recodeName.text = model.patintName;
    self.recordDescription.text = model.machineReport;
    self.recordTime.text = model.time;
}

@end
