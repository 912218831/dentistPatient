//
//  HWAppointSuccessCell.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/14.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointSuccessCell.h"
#import "HCSStarRatingView.h"
#import "HWAppointDetailModel.h"
#import "HWAppointSuccessViewModel.h"
@interface HWAppointSuccessCell()
@property (weak, nonatomic) IBOutlet UILabel *docNameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *patientCountLab;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;//采纳医生建议
@property (weak, nonatomic) IBOutlet UILabel *appointDateLab;
@property(strong,nonatomic)HWAppointSuccessViewModel * viewModel;
@end

@implementation HWAppointSuccessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//[self.moneyTF.rac_textSignal subscribeNext:^(id x) {
//    NSLog(@"%@",x);
//}];
}

- (void)bindViewModel:(id)viewModel
{
    self.viewModel = viewModel;
    HWAppointDetailModel * detailModel = (HWAppointDetailModel *)self.viewModel.detailModel;
    self.docNameLab.text = detailModel.dentistName;
    self.addressLab.text = detailModel.address;
    self.patientCountLab.text = detailModel.patientCount;
    self.appointDateLab.text = detailModel.expectedTime;
    self.starView.value = detailModel.docLevel.integerValue;
    
}

@end
