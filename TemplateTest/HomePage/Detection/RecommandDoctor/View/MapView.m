//
//  MapView.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "MapView.h"
#import "RDoctorListCell.h"
#import "MapContentView.h"

@interface MapView () <MAMapViewDelegate>
@property (nonatomic, strong) MapContentView *contentV;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) RDoctorListCell *cell;
@property (nonatomic, strong) NSMutableArray *annotations;
@end

@implementation MapView


- (instancetype)init {
    if (self = [super init]) {
        [self initSubViews];
        [self layoutSubViews];
        [self initDefaultConfigs];
    }
    return self;
}

- (void)initSubViews {
    self.contentV = [MapContentView buttonWithType:UIButtonTypeCustom];
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
    self.cell.userInteractionEnabled = false;
}

- (void)bindSignal {
    @weakify(self);
    [self.valueSignal subscribeNext:^(RACTuple *x) {
        @strongify(self);
        [self.cell setValueSignal:[RACSignal return:x.first]];
        [self.contentV setAnnotationsSignal:[RACSignal return:RACTupleArray(x.second)]];
    }];
}

- (RACSubject *)locationSuccess {
    return self.contentV.locationSuccess;
}

- (RACSubject *)locationFail {
    return self.contentV.locationFail;
}

@end
