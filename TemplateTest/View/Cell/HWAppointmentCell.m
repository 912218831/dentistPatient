//
//  HWAppointmentCell.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/13.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointmentCell.h"

@interface HWAppointmentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;

@property (weak, nonatomic) IBOutlet UILabel *docNameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *complementStateLab;

@end

@implementation HWAppointmentCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(HWAppointListModel *)model
{
    [self.headerImgV sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:placeHoderImg];
    self.docNameLab.text = model.dentistName;
    self.addressLab.text = model.clinicName;
    self.timeLab.text = model.expectedTime;
    self.complementStateLab.text = model.stateDes;
}

@end
