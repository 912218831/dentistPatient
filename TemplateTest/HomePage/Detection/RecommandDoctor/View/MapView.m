//
//  MapView.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "MapView.h"
#import "RDoctorListCell.h"

@interface MapView () <MAMapViewDelegate>
@property (nonatomic, strong) MAMapView *contentV;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) RDoctorListCell *cell;
@property (nonatomic, strong) NSMutableArray *annotations;
@end

@implementation MapView


- (void)initSubViews {
    self.contentV = [[MAMapView alloc] initWithFrame:(CGRect){CGPointZero, kScreenWidth, kRate(220)}];
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
    
    self.contentV.showsUserLocation = true;
    self.contentV.userTrackingMode = MAUserTrackingModeFollow;
    self.contentV.delegate = self;
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
    
    [self initAnnotations];
}

- (void)bindSignal {
    //@weakify(self);
    [self.cell setValueSignal:self.valueSignal];
}


#pragma mark - Initialization
- (void)initAnnotations
{
    self.annotations = [NSMutableArray array];
    
    CLLocationCoordinate2D coordinates[10] = {
        {31.3501330000, 121.5672620000},
        {31.3480070000, 121.5675200000},
        {39.998293, 116.352343},
        {40.004087, 116.348904},
        {40.001442, 116.353915},
        {39.989105, 116.353915},
        {39.989098, 116.360200},
        {39.998439, 116.360201},
        {39.979590, 116.324219},
        {39.978234, 116.352792}};
    
    for (int i = 0; i < 10; ++i)
    {
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        a1.coordinate = coordinates[i];
        a1.title      = [NSString stringWithFormat:@"anno: %d", i];
        [self.annotations addObject:a1];
    }
    
    [self.contentV addAnnotations:self.annotations];
    //[self.contentV showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(200, 100, 200, 200) animated:YES];
}

#pragma mark -- MAMapViewDelegate
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
    MACoordinateSpan span = MACoordinateSpanMake(0.004913, 0.013695);
    MACoordinateRegion region = MACoordinateRegionMake(self.contentV.centerCoordinate, span);
    self.contentV.region = region;
}

-(void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CLLocationCoordinate2D coordinate = self.contentV.region.center;
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
