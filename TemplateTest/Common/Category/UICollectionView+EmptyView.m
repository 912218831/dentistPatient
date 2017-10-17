//
//  UICollectionView+EmptyView.m
//  TemplateTest
//
//  Created by HW on 2017/10/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "UICollectionView+EmptyView.h"

#define kEmptyTag 100

@implementation UICollectionView (EmptyView)

- (void)setNeedShowEmpty:(BOOL)needShowEmpty {
    objc_setAssociatedObject(self, _cmd, @(needShowEmpty), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)needShowEmpty {
    id value = objc_getAssociatedObject(self, @selector(setNeedShowEmpty:));
    return [value boolValue];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    //
}

- (void)hideEmptyView {
    UIView *em = [self viewWithTag:kEmptyTag];
    [em removeFromSuperview];
}

- (void)showEmptyView {
    UILabel *label = [self viewWithTag:kEmptyTag];
    if (!label) {
        label = [UILabel new];
        label.text = @"暂无数据";
        label.textColor = CD_Text99;
        label.font = FONT(kRate(TF15));
        label.tag = kEmptyTag;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    } else {
        [self bringSubviewToFront:label];
    }
}

@end
