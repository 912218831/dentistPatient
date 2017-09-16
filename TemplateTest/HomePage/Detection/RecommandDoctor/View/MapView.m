//
//  MapView.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "MapView.h"
#import "RDoctorListCell.h"

@interface MapView ()
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) RDoctorListCell *cell;
@end

@implementation MapView


- (void)initSubViews {
    self.contentV = [UIView new];
    [self addSubview:self.contentV];
    
    self.shadowImageView = [UIImageView new];
    [self.contentV addSubview:self.shadowImageView];
    
    self.cell = [[RDoctorListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [self addSubview:self.cell];
}

- (void)layoutSubViews {
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(kRate(220));
    }];
    [self.shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentV);
        make.height.mas_equalTo(kRate(53));
    }];
    [self.cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-1);
        make.left.right.equalTo(self);
        make.top.equalTo(self.shadowImageView.mas_bottom).with.offset(-kRate(18));
    }];
}

- (void)initDefaultConfigs {
    self.shadowImageView.image = [UIImage imageNamed:@"selectDoctor_icon"];
    self.contentV.backgroundColor = [UIColor redColor];
    self.backgroundColor = [UIColor clearColor];
    self.cell.backgroundColor = [UIColor clearColor];
}

- (void)bindSignal {
    //@weakify(self);
    [self.cell setValueSignal:self.valueSignal];
}

@end
