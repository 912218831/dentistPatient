//
//  WifiListView.h
//  HKSDKDemo
//
//  Created by 杨庆龙 on 2017/9/27.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WifiInfoModel;

@protocol WifiListViewDelegate

- (void)cellDidselect:(id)wifiInfo;

@end

@interface WifiListView : UIView
@property(strong,nonatomic)NSDictionary * lanDeviceDic;
@property(strong,nonatomic)NSArray * dataArr;
@property(strong,nonatomic)id<WifiListViewDelegate>  delegate;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;

@end
