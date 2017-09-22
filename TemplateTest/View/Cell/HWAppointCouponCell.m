//
//  HWAppointCouponCell.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/14.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointCouponCell.h"
#import "HWAppointCouponModel.h"
@interface HWAppointCouponCell()

@property(nonatomic,strong)HWAppointCouponModel * model;
@property (weak, nonatomic) IBOutlet UILabel *minMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *reduceMoneyLab;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;

@end

@implementation HWAppointCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse
{
    
}

- (void)bindViewModel:(id)viewModel
{
    self.model = viewModel;
    self.minMoneyLab.text = self.model.minConsumptionPrice;
    self.reduceMoneyLab.text = self.model.deductiblePrice;
    if (self.model.selected) {
        self.bgImgV.image = ImgWithName(@"优惠券_选中");
    }
    else
    {
        self.bgImgV.image = ImgWithName(@"优惠券");

    }
}
@end
