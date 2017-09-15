//
//  HWDashView.m
//  RecocoaDemo
//
//  Created by 杨庆龙 on 2017/9/14.
//  Copyright © 2017年 杨庆龙. All rights reserved.
//

#import "HWDashView.h"

@implementation HWDashView{
    UIColor * _lineColor;
    BOOL _vertical;
}
@dynamic lineColor;
@dynamic vertical;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _vertical = NO;
        _lineColor = [UIColor blackColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _vertical = NO;
        _lineColor = [UIColor blackColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGPoint startPoint;
    CGPoint endPoint;
    if (_vertical) {
        startPoint = CGPointMake(CGRectGetMidX(rect), 0);
        endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetHeight(rect));
    }
    else
    {
        startPoint = CGPointMake(0, CGRectGetMidY(rect));
        endPoint = CGPointMake(CGRectGetWidth(rect), CGRectGetMidY(rect));
    }
    [super drawRect:rect];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置虚线颜色
    CGContextSetStrokeColorWithColor(currentContext, _lineColor.CGColor);
    //设置虚线宽度
    CGContextSetLineWidth(currentContext, 1);
    //设置虚线绘制起点
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    //设置虚线绘制终点
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
    CGFloat arr[] = {3,1};
    //下面最后一个参数“2”代表排列的个数。
    CGContextSetLineDash(currentContext, 0, arr, 2);
    CGContextDrawPath(currentContext, kCGPathStroke);
}
@end
