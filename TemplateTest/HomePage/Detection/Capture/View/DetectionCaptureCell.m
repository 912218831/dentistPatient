//
//  DetectionCaptureCell.m
//  TemplateTest
//
//  Created by HW on 17/9/15.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DetectionCaptureCell.h"
#import "DetectionCaptureModel.h"

@interface DetectionCaptureCell ()
@property (nonatomic, strong, readwrite) UIImageView *photoImageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIView *coverView;
@end

@implementation DetectionCaptureCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
        [self layoutSubViews];
        [self initDefaultConfigs];
    }
    return self;
}

- (void)initSubViews {
    self.photoImageView = [UIImageView new];
    [self addSubview:self.photoImageView];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.deleteBtn];
    
    self.coverView = [UIView new];
    [self addSubview:self.coverView];
    
    self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self addSubview:self.indicatorView];
}

- (void)layoutSubViews {
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.top.mas_equalTo(kRate(6));
        make.right.mas_equalTo(-kRate(5));
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRate(24), kRate(24)));
    }];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.photoImageView);
    }];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.photoImageView);
    }];
}

- (void)initDefaultConfigs {
    self.coverView.backgroundColor =COLOR_000000;
    self.coverView.alpha = 0.5;
    self.coverView.hidden = true;
    self.indicatorView.hidden = true;
    self.deleteBtn.layer.cornerRadius = kRate(12);
    [self.deleteBtn setImage:[UIImage imageNamed:@"detectionPhotoDelete"] forState:UIControlStateNormal];
}

- (void)setNeedBorder:(BOOL)needBorder {
    if (needBorder) {
        self.photoImageView.layer.cornerRadius = 3;
        self.photoImageView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        self.photoImageView.layer.borderWidth = 0.5;
        self.photoImageView.layer.backgroundColor = COLOR_FFFFFF.CGColor;
    } else {
        self.photoImageView.layer.backgroundColor = COLOR_FFFFFF.CGColor;
    }
}

- (void)setValueSignal:(RACSignal *)valueSignal {
    _valueSignal = valueSignal;
    [self bindSignal];
}

- (void)bindSignal {
    @weakify(self);
    [self.valueSignal subscribeNext:^(DetectionCaptureModel *model) {
        @strongify(self);
        if (model.image) {
            self.photoImageView.image = model.image;
            if (model.needUpload) {
                self.indicatorView.hidden = false;
                self.coverView.hidden = false;
                self.deleteBtn.enabled = false;
                [self.indicatorView startAnimating];
                model.uploadFinished = ^(BOOL uploadSuccess) {
                    NSLog(@"成功或者失败=%d",uploadSuccess);
                    self.indicatorView.hidden = true;
                    self.coverView.hidden = true;
                    self.deleteBtn.enabled = true;
                    [self.indicatorView stopAnimating];
                };
            }
        } else {
            self.indicatorView.hidden = true;
            self.coverView.hidden = true;
            self.deleteBtn.enabled = true;
            [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
        }
    }];
    
    self.deleteAction = [self.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside];
}

@end
