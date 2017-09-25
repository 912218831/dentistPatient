//
//  HWDecetionSelectMemberCell.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/14.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWDecetionSelectMemberCell.h"


@interface HWDecetionSelectMemberCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedBackgroundView;
@end

@implementation HWDecetionSelectMemberCell
@dynamic selectedBackgroundView;
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textColor = CD_Text;
    self.backgroundView = [[UIView alloc]initWithFrame:self.bounds];
    self.backgroundView.layer.cornerRadius = 3;
    self.backgroundView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.backgroundView.backgroundColor = COLOR_FFFFFF;
    self.backgroundView.layer.borderWidth = 1;
    
    [self bindSignal];
}

- (void)bindSignal {
    @weakify(self);
    [[[RACObserve(self, model) filter:^BOOL(id value) {
        return value;
    }] distinctUntilChanged]subscribeNext:^(FamilyMemberModel *x) {
        @strongify(self);
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:x.image] placeholderImage:[UIImage imageNamed:@"selectPeople"]];
        self.titleLabel.text = x.name;
    }];
}

@end
