//
//  MapContentView.h
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "BaseView.h"

@interface MapContentView : UIButton
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) RACSignal *annotationsSignal;
@end
