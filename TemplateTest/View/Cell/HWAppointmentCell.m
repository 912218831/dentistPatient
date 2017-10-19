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
    self.headerImgV.layer.cornerRadius = 40.0f;
    self.headerImgV.layer.masksToBounds = YES;
}

- (void)setModel:(HWAppointListModel *)model
{
    [self.headerImgV sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:placeHoderImg];
    self.docNameLab.text = model.dentistName;
    self.addressLab.text = model.clinicName;
    self.timeLab.text = model.expectedTime;
    self.complementStateLab.text = model.stateDes;
    /*
      1-等医生确认 , 2-放弃 , 3-预约成功 , 4-等病人确认(医生改日期) , 5-就诊完成 , 7-删除
     */
    if ([model.state isEqualToString:@"2"] || [model.state isEqualToString:@"7"]) {
        //
        self.complementStateLab.backgroundColor = COLOR_999999;
    }
    else if([model.state isEqualToString:@"4"])
    {
        self.complementStateLab.backgroundColor = COLOR_00BF55;//
    }
    else if ([model.state isEqualToString:@"1"])
    {
        self.complementStateLab.backgroundColor = COLOR_00BF55;//
    }
    else if([model.state isEqualToString:@"3"])
    {
        self.complementStateLab.backgroundColor = COLOR_EC7E33;

    }
    else if([model.state isEqualToString:@"5"])
    {
        self.complementStateLab.backgroundColor = COLOR_4FB3DE;

    }
    else
    {
        self.complementStateLab.backgroundColor = COLOR_00BF55;
    }
    
}


@end
