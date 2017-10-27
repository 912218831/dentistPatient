//
//  HWAppoitmentFailCell.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/13.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppoitmentFailCell.h"
#import "HCSStarRatingView.h"
#import "BaseProtocol.h"
#import "HWAppointFailViewModel.h"
#import "HWAppointDetailModel.h"
@interface HWAppoitmentFailCell()

@property (weak, nonatomic) IBOutlet UILabel *docNameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *patientCountLab;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;//采纳医生建议
@property(strong,nonatomic)HWAppointFailViewModel * viewModel;
@property (weak, nonatomic) IBOutlet UILabel *exceptDateLab;

@end

@implementation HWAppoitmentFailCell

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
    self.docNameLab.text = detailModel.dentistName;
    self.addressLab.text = detailModel.address;
    self.patientCountLab.text = detailModel.patientCount;
    self.starView.value = detailModel.docLevel.integerValue;
    self.acceptBtn.rac_command = self.viewModel.acceptCommand;
    self.rejectBtn.rac_command = self.viewModel.rejectCommand;
    self.exceptDateLab.text = detailModel.docExpectedTime;
}


@end
