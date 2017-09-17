//
//  PatientDetailDateCell.m
//  TemplateTest
//
//  Created by HW on 17/9/6.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "PatientDetailDateView.h"
#import "DashLineView.h"
#import "DoctorDetailTimeListModel.h"

#define UIRectCornerNone (0)
#define kCol (4.0)
@interface PatientDetailDateView ()
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) NSMutableArray *titleLables;
@property (nonatomic, strong) UILabelWithCorner *selectedLabel;
@end

@implementation PatientDetailDateView

- (void)initSubViews {
    self.contentV = [UIView new];
    [self addSubview:self.contentV];
}

- (void)layoutSubViews {
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

- (void)initDefaultConfigs {
    self.backgroundColor = COLOR_F3F3F3;
    
    self.contentV.layer.backgroundColor = COLOR_FFFFFF.CGColor;
    self.contentV.layer.cornerRadius = 0;
    self.contentV.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.contentV.layer.borderWidth = 0.6;
}

- (void)setValueSignal:(RACSignal *)valueSignal {
    @weakify(self);
    [[valueSignal deliverOn:[RACScheduler mainThreadScheduler]]subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        NSInteger allRow = ceil(tuple.allObjects.count/kCol);
        CGFloat w = self.width/kCol;
        CGFloat h = self.height/allRow;
        __block CGFloat x = 0;
        __block CGFloat y = 0;
        [tuple.rac_sequence foldLeftWithStart:@0 reduce:^id(NSNumber *accumulator, DoctorDetailTimeListModel *value) {
            NSInteger row = accumulator.integerValue/kCol;
            NSInteger col = accumulator.integerValue%(int)kCol;
            // 初始化
            UILabelWithCorner *label = [[UILabelWithCorner alloc]init];
            label.indexPath = [NSIndexPath indexPathForRow:row inSection:col];
            [self.contentV addSubview:label];
            [self.titleLables addObject:label];
            // 布局
            x = col*w;
            y = row*h;
            label.frame = CGRectMake(x, row==0?1:y, (col==kCol-1)?w:w+1, h);
            // 赋值
            label.font = FONT(TF14);
            label.textColor = CD_Text99;
            label.text = value.title;
            label.backgroundColor = COLOR_FFFFFF;
            label.textAlignment = NSTextAlignmentCenter;
            // 监听点击事件
            [[[label rac_signalForControlEvents:UIControlEventTouchUpInside]filter:^BOOL(UILabelWithCorner *value) {
                return YES;
            }]subscribeNext:^(id x) {
                label.backgroundColor = UIColorFromRGB(0xdff5fe);
                label.textColor = CD_MainColor;
                self.selectedLabel.backgroundColor = COLOR_FFFFFF;
                self.selectedLabel.textColor = CD_Text99;
                self.selectedLabel = label;
            }];
            return @(accumulator.integerValue + 1);
        }];
        // 画线
        for (int row=1; row<allRow; row++) {
            DashLineView *hLine = [[DashLineView alloc]initWithLineHeight:kScreenWidth - kRate(30) space:0 direction:Horizontal strokeColor:COLOR_999999];
            [self.contentV addSubview:hLine];
            [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentV);
                make.bottom.equalTo(self.contentV.mas_top).with.offset(row*h-1);
                make.height.mas_equalTo(0.6);
            }];
        }
        for (int i=1; i<kCol; i++) {
            DashLineView *vLineOne = [[DashLineView alloc]initWithLineHeight:h*2 space:0 direction:Vertical strokeColor:COLOR_999999];
            [self.contentV addSubview:vLineOne];
            [vLineOne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentV);
                make.left.equalTo(self.contentV).with.offset(i*w);
                make.width.mas_equalTo(0.6);
                make.bottom.equalTo(self.contentV);
            }];
        }
    }];
}

- (void)dealloc {
    
}

@end



@interface UILabelWithCorner ()
@property (nonatomic, strong) UILabel *label;
@end
@implementation UILabelWithCorner

#pragma mark --- 设置 view layer 的 class
+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (instancetype)init {
    if (self = [super init]) {
        self.label = [UILabel new];
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self);
        }];
        @weakify(self);
        [RACObserve(self, backgroundColor)subscribeNext:^(id x) {
            @strongify(self);
            CAShapeLayer *shape = (CAShapeLayer *)self.layer;
            shape.fillColor = self.backgroundColor.CGColor;
        }];
        /*
         这里用 rac_signalForSelector: 方法会有一个隐患，当 UITextfield、UITextView 等相关控件被使用（也就是 ）之后，会与 setBackgroundColor swizzle生成的方法产生冲突（目测只与改变外观的 swizzle 发生冲突），网上人说是 UIKit 框架的 bug,目前没办法解决
         （
         https://github.com/taplytics/taplytics-ios-sdk/issues/29
         
         First, what caused the crash on my project was using UIAppearance selector to change autocorrection mode for UITextFields, UITextViews and UISearchBars. But I ended up realizing it's an internal iOS bug, because on the assertion crash log Apple even prints out "if you see this assertion failing, please fill out a bug report in https://etc..."
         ）
         [[self rac_signalForSelector:@selector(setBackgroundColor:)]subscribeNext:^(id x) {
         }];
         */
        
    }
    return self;
}

- (void)setCorner:(UIRectCorner)corner {
    _corner = corner;
    if (corner != UIRectCornerNone) {
        CAShapeLayer *shape = (CAShapeLayer *)self.layer;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(3, 3)];
        shape.path = path.CGPath;
        shape.fillColor = self.backgroundColor.CGColor;
        [shape setBackgroundColor:[UIColor clearColor].CGColor];
    }
}

- (void)setFont:(UIFont *)font {
    self.label.font = font;
}

- (void)setText:(NSString *)text {
    self.label.text = text;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    self.label.textAlignment = textAlignment;
}

- (void)setTextColor:(UIColor *)textColor {
    self.label.textColor = textColor;
}
@end
