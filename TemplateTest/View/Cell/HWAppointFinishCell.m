//
//  HWAppointFinishCell.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/10/13.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointFinishCell.h"
#import "HWAppointWaitingViewModel.h"
#include "HCSStarRatingView.h"
@interface HWAppointFinishCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *appointCountLab;
@property (weak, nonatomic) IBOutlet UILabel *appointStateLab;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLab;
@property(strong,nonatomic)HWAppointWaitingViewModel * viewModel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;

@end

@implementation HWAppointFinishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindViewModel:(id)viewModel
{
    self.viewModel = viewModel;
    HWAppointDetailModel * detailModel = self.viewModel.detailModel;
    self.nameLab.text = detailModel.dentistName;
    self.addressLab.text = detailModel.clinicName;
    self.appointCountLab.text = detailModel.patientCount;
    self.appointStateLab.text = detailModel.stateDes;
    self.payMoneyLab.text = detailModel.payInfo;
    self.starView.value = detailModel.docLevel.integerValue;

}

@end
