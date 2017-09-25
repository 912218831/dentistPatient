//
//  HWLoginTelphoneCell.h
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/7.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWLoginCellViewModel.h"

@interface HWLoginTelphoneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *telphoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;

@property(strong,nonatomic)HWLoginCellViewModel * viewModel;

@end
