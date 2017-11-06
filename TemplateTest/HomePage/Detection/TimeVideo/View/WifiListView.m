//
//  WifiListView.m
//  HKSDKDemo
//
//  Created by 杨庆龙 on 2017/9/27.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "WifiListView.h"
#import "WifiInfoModel.h"
#import <HKDecodeGlobal.h>
#import <IQUIView+Hierarchy.h>
@interface WifiListView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(strong,nonatomic)NSString * wifiPWD;
@end

@implementation WifiListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataArr = [[NSArray alloc] init];
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
}

- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    self.isWifiList = YES;
    [self.table reloadData];
}

- (void)setLanDeviceDic:(NSDictionary *)lanDeviceDic
{
    _lanDeviceDic = lanDeviceDic;
    self.isWifiList = NO;
    [self.table reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isWifiList) {
        return self.dataArr.count;
    }
    else
    {
        return self.lanDeviceDic.allKeys.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    if (self.isWifiList) {
        WifiInfoModel * model = [self.dataArr objectAtIndex:indexPath.row];
        cell.textLabel.text = model.sid;
    }
    else
    {
        HekaiDeviceDesc *device = [self.lanDeviceDic objectForKey:[self.lanDeviceDic.allKeys objectAtIndex:indexPath.row]];
        cell.textLabel.text = [NSString stringWithUTF8String:device.deviceDesc.deviceId];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isWifiList) {
        WifiInfoModel * model = [self.dataArr objectAtIndex:indexPath.row];
        UIAlertController * alertCtrl = [UIAlertController alertControllerWithTitle:@"请输入wifi密码" message:model.sid preferredStyle:UIAlertControllerStyleAlert];
        @weakify(self);
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            if (self.wifiPWD.length < 8) {
                [Utility showToastWithMessage:@"请输入密码"];
                return;
            }
            [self.selectWifiCommand execute:RACTuplePack(model.sid,self.wifiPWD,[model copy])];
            self.isWifiList = NO;
            [self.table reloadData];
        }];
        [alertCtrl addAction:cancelAction];
        [alertCtrl addAction:sureAction];
        [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            @strongify(self);
            textField.placeholder = @"请输入wifi密码";
            textField.secureTextEntry = NO;
            [[textField.rac_textSignal skip:1] subscribeNext:^(NSString * x) {
                self.wifiPWD = x;
            }];
        }];
        [self.viewController presentViewController:alertCtrl animated:YES completion:nil];
    }
    else
    {
        HekaiDeviceDesc *device = [self.lanDeviceDic objectForKey:[self.lanDeviceDic.allKeys objectAtIndex:indexPath.row]];
        [self.selectDeviceCommand execute:[NSString stringWithUTF8String:device.deviceDesc.deviceId]];
//        if (self.delegate != nil) {
//            [self.delegate cellDidselect:[NSString stringWithUTF8String:device.deviceDesc.deviceId]];
//        }
    }
    
}

@end
