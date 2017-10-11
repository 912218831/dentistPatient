//
//  ResultStateTerribleView.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "ResultStateTerribleView.h"
#import "DetectionIssueItemModel.h"
#import "HZPhotoBrowser.h"

@interface ResultStateTerribleView () <HZPhotoBrowserDelegate>
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *recommandNoteLabel;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation ResultStateTerribleView

- (void)initSubViews {
    self.contentView = [UIView new];
    [self addSubview:self.contentView];
    
    self.iconImageView = [UIImageView new];
    [self addSubview:self.iconImageView];
    
    self.titleLabel = [UILabel new];
    [self addSubview:self.titleLabel];
    
    self.recommandNoteLabel = [UILabel new];
    [self addSubview:self.recommandNoteLabel];
}

- (void)layoutSubViews {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRate(120), kRate(75)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(kRate(44));
    }];
    [self.recommandNoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
    }];
}

- (void)initDefaultConfigs {
    self.iconImageView.image = [UIImage imageNamed:@"detectionResultT"];
    
    self.titleLabel.font = FONT(TF15);
    self.titleLabel.textColor = CD_Text33;
    self.titleLabel.text = @"检测完成，但发现了些问题";
    
    self.recommandNoteLabel.font = FONT(TF16);
    self.recommandNoteLabel.textColor = CD_MainColor;
    self.recommandNoteLabel.text = @"系统正在为你推荐医生";
}

- (void)setIssueSignal:(RACSignal *)issueSignal {
    @weakify(self);
    [issueSignal subscribeNext:^(RACTuple *x) {
        @strongify(self);
        CGFloat offY = kRate(163);
        CGFloat marginX = kRate(15);
        CGFloat spaceX = kRate(10);
        CGFloat spaceY = kRate(10);
        NSInteger colN = 3;
        CGFloat w = (kScreenWidth - (colN-1)*spaceX - 2*marginX)/colN;
        CGFloat h = w;
        
        self.images = x.allObjects;
        CGFloat left = marginX;
        CGFloat top = 0;
        
        for (int i=0; i<x.allObjects.count; i++) {
            NSInteger row = i/colN;
            NSInteger col = i%colN;
            
            left = marginX + col * (spaceX + w);
            top =  row * (spaceY + h);
            
            DetectionIssueItemModel *model = [x.allObjects pObjectAtIndex:i];
            UIImageView *imageView = [UIImageView new];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"whiteplaceholder"]];
            imageView.userInteractionEnabled = true;
            imageView.tag = 100+i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [imageView addGestureRecognizer:tap];
            [self.contentView addSubview:imageView];
            imageView.frame = CGRectMake(left, top, w, h);
        }
        
        top += spaceY + h;
        
        [self.recommandNoteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self);
            make.top.equalTo(self.contentView.mas_bottom).with.offset(kRate(15));
        }];
        self.contentView.frame = CGRectMake(0, offY, kScreenWidth, top);
        self.frame = (CGRect){self.frame.origin, self.frame.size.width, CGRectGetMaxY(self.contentView.frame)+ kRate(60)};
      }];
}

- (void)tapAction:(UIGestureRecognizer *)tap {
    UIView *imageV = tap.view;
    //启动图片浏览器
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self.contentView; // 原图的父控件
    browser.imageCount = self.images.count; // 图片总数
    browser.currentImageIndex = (int)[self.contentView.subviews indexOfObject:imageV];
    browser.delegate = self;
    [browser show];
}

- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UIImageView *imageView = [self.contentView.subviews objectAtIndex:index];
    return imageView.image;
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    DetectionIssueItemModel *model = [self.images objectAtIndex:index];
    return [NSURL URLWithString:model.imageUrl];
}

@end
