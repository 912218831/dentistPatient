//
//  HWAppoitmentFailCell.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/13.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWAppointFailViewModel.h"
@interface HWAppoitmentFailCell : UITableViewCell<HWBaseViewProtocol>
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;//采纳医生建议
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;//返回重新预约

@end
