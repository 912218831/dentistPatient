//
//  MapContentView.m
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "MapContentView.h"

@interface MapContentView () <MAMapViewDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, assign) BOOL settedRegion;
@end

@implementation MapContentView

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    MapContentView *btn = [super buttonWithType:buttonType];
    [btn initSubViews];
    [btn layoutSubViews];
    [btn initDefaultConfigs];
    return btn;
}

- (void)initSubViews {
    self.mapView = [[MAMapView alloc]initWithFrame:self.bounds];
    [self addSubview:self.mapView];
}

- (void)layoutSubViews {
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self);
    }];
}

- (void)initDefaultConfigs {
    
    self.mapView.showsUserLocation = true;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.delegate = self;
    self.mapView.runLoopMode = NSDefaultRunLoopMode;
    /*
     MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
     r.showsAccuracyRing = NO;///精度圈是否显示，默认YES
     r.showsHeadingIndicator = NO;///是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
     r.fillColor = [UIColor redColor];///精度圈 填充颜色, 默认 kAccuracyCircleDefaultColor
     r.strokeColor = [UIColor blueColor];///精度圈 边线颜色, 默认 kAccuracyCircleDefaultColor
     r.lineWidth = 2;///精度圈 边线宽度，默认0
     r.enablePulseAnnimation = YES;///内部蓝色圆点是否使用律动效果, 默认YES
     r.locationDotBgColor = [UIColor greenColor];///定位点背景色，不设置默认白色
     r.locationDotFillColor = [UIColor grayColor];///定位点蓝色圆点颜色，不设置默认蓝色
     [self.contentV updateUserLocationRepresentation:r];*/
    
    self.locationSuccess = [RACSubject subject];
    self.locationFail = [RACSubject subject];
}

#pragma mark - Initialization
- (void)setAnnotationsSignal:(RACSignal *)annotationsSignal {
    @weakify(self);
    [annotationsSignal subscribeNext:^(RACTuple *x) {
        @strongify(self);
        [[RACScheduler mainThreadScheduler]schedule:^{
            [self.mapView addAnnotations:x.allObjects];
            if (self.needAnnotationCenter) {
                MACoordinateSpan span = MACoordinateSpanMake(0.004913, 0.013695);
                MAPointAnnotation *an = x.first;
                MACoordinateRegion region = MACoordinateRegionMake(an.coordinate, span);
                self.mapView.region = region;
            }
        }];
        
    }];
}

#pragma mark -- MAMapViewDelegate (经纬度不合法，是不会调用的)
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    MAPinAnnotationView *pinView = nil;
    
    if(annotation == mapView.userLocation) {
        return pinView;
    }
    
    static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
    MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
    if (annotationView == nil)
    {
        annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
    }
    
    annotationView.canShowCallout               = YES;
    annotationView.animatesDrop                 = false;//YES;
    annotationView.draggable                    = YES;
    annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.pinColor                     = [self.annotations indexOfObject:annotation] % 3;
    
    return annotationView;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    // 定位
    if (!self.settedRegion&&!self.needAnnotationCenter) {
        MACoordinateSpan span = MACoordinateSpanMake(0.004913, 0.013695);
        MACoordinateRegion region = MACoordinateRegionMake(mapView.centerCoordinate, span);
        self.mapView.region = region;
        
        self.settedRegion = true;
        
        [self.locationSuccess sendNext:[NSValue valueWithMACoordinate:mapView.centerCoordinate]];
    }
    
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    [self.locationFail sendNext:error];
}

-(void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CLLocationCoordinate2D coordinate = mapView.region.center;
    NSLog(@"%f, %f",coordinate.latitude, coordinate.longitude);
}

/*!
 @brief 当选中一个annotation views时调用此接口
 @param mapView 地图View
 @param views 选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    NSLog(@"点击了");
}

/*!
 @brief 当取消选中一个annotation views时调用此接口
 @param mapView 地图View
 @param views 取消选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    NSLog(@"取消了");
}

/*!
 @brief 标注view的accessory view(必须继承自UIControl)被点击时调用此接口
 @param mapView 地图View
 @param annotationView callout所属的标注view
 @param control 对应的control
 */
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}

@end
