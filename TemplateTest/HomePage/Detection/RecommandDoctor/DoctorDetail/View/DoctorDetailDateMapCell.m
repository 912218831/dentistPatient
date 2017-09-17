//
//  DoctorDetailDateMapCell.m
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DoctorDetailDateMapCell.h"
#import "MapContentView.h"
#import "PatientDetailDateView.h"

@interface DoctorDetailDateMapCell ()
@property (nonatomic, strong) MapContentView *mapView;
@property (nonatomic, strong) PatientDetailDateView *dateView;
@end

@implementation DoctorDetailDateMapCell

- (void)initSubViews {
    self.mapView = [MapContentView buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.mapView];
    
    self.dateView = [PatientDetailDateView new];
    [self addSubview:self.dateView];
}

- (void)layoutSubViews {
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(kRate(159));
    }];
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.mapView.mas_bottom);
    }];
}

- (void)initDefaultConfigs {
    self.mapView.mapView.showsUserLocation = true;
    [self.dateView setValueSignal:[RACSignal return:RACTuplePack(@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"")]];
    
    
}

@end
