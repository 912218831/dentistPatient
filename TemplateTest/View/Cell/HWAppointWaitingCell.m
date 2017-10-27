//
//  HWAppointWaitingCell.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/14.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointWaitingCell.h"
#import "HCSStarRatingView.h"
#import "HWAppointWaitingViewModel.h"
@interface HWAppointWaitingCell()

@property (weak, nonatomic) IBOutlet UILabel *docNameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *patientCountLab;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;//采纳医生建议
@property(strong,nonatomic)HWAppointWaitingViewModel * viewModel;


@end

@implementation HWAppointWaitingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)bindViewModel:(id)viewModel
{
    self.viewModel = viewModel;
    HWAppointDetailModel * detailModel = self.viewModel.detailModel;
    self.docNameLab.text = detailModel.dentistName;
    self.addressLab.text = detailModel.address;
    self.patientCountLab.text = detailModel.patientCount;
    self.starView.value = detailModel.docLevel.integerValue;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
