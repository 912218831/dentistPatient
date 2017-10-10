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
@property (nonatomic, assign) BOOL locateSuccess;
@end

@implementation MapContentView

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    MapContentView *btn = [super buttonWithType:buttonType];
    [btn initSubViews];
    [btn initDefaultConfigs];
    return btn;
}

- (void)initSubViews {
    self.mapView = [[MAMapView alloc]initWithFrame:self.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = true;
    self.mapView.zoomLevel = 17;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self addSubview:self.mapView];
}

- (void)initDefaultConfigs {
    
    self.locationSuccess = [RACSubject subject];
    self.locationFail = [RACSubject subject];
}

- (void)setNeedAnnotationCenter:(BOOL)needAnnotationCenter {
    self.mapView.showsUserLocation = !needAnnotationCenter;
    _needAnnotationCenter = needAnnotationCenter;
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
    if (updatingLocation&&!self.locateSuccess) {
        //self.mapView.openGLESDisabled = true;
        [self.locationSuccess sendNext:[NSValue valueWithMACoordinate:mapView.centerCoordinate]];
        self.locateSuccess = true;
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
