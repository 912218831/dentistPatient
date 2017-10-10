//
//  CaseSegmentButton.m
//  TemplateTest
//
//  Created by HW on 17/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "CaseSegmentButton.h"

@interface CaseSegmentButton ()<HWBaseViewProtocol>
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation CaseSegmentButton

- (instancetype)init {
    if (self = [super init]) {
        [self initSubViews];
        [self initDefaultConfigs];
    }
    return self;
}

- (void)initSubViews {
    self.titleLabel = [UILabel new];
    [self addSubview:self.titleLabel];
    
    self.iconImageView = [UIImageView new];
    [self addSubview:self.iconImageView];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    
    [self.titleLabel sizeToFit];
    CGSize titleSize = self.titleLabel.size;
    CGSize imageSize = self.iconImageView.image.size;
    CGFloat spaceX = kRate(10);
    CGFloat contenX = titleSize.width + imageSize.width + spaceX;
    CGFloat x = (self.width - contenX)/2.0;
    self.titleLabel.frame = (CGRect){x, 0, titleSize.width, self.height};
    
    x +=  titleSize.width+spaceX;
    self.iconImageView.frame = (CGRect){x, (self.height-imageSize.height)/2.0, imageSize};
}

- (void)initDefaultConfigs {
    self.titleLabel.font = FONT(TF16);
    self.titleLabel.textColor = COLOR_FFFFFF;
    self.iconImageView.image = [UIImage imageNamed:@"arrow_down"];
    
}

@end
