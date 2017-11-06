//
//  SettingDeviceViewController.m
//  TemplateTest
//
//  Created by HW on 2017/11/4.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "SettingDeviceViewController.h"
#import "WifiListView.h"
#import "SettingDeviceViewModel.h"

@interface SettingDeviceViewController ()<UIAlertViewDelegate ,UITableViewDelegate, UITableViewDataSource, WifiListViewDelegate>
@property (nonatomic, strong) UITableView *listView;
@property (strong, nonatomic) WifiListView * wifiListView;
@property (nonatomic, strong) SettingDeviceViewModel *viewModel;
@end

@implementation SettingDeviceViewController
@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:false];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)configContentView {
    [super configContentView];
    
    self.listView = [[UITableView alloc]initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
    [self addSubview:self.listView];
    self.listView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.listView.dataSource = self;
    self.listView.delegate = self;
    
    self.wifiListView = [[[NSBundle mainBundle] loadNibNamed:@"WifiListView" owner:self options:nil] firstObject];
    self.wifiListView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 300);
    [self addSubview:self.wifiListView];
    self.wifiListView.delegate = self;
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self);
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil]subscribeNext:^(NSNotification *x) {
        @strongify(self);
        if(![self.viewModel startConfig]){
            return ;
        }
        [self.viewModel.listDataChannel.leadingTerminal subscribeNext:^(id x) {
            @strongify(self);
            if ([x isKindOfClass:[NSArray class]]) {
                //wifi列表
                SettingModel *model = [self.viewModel.titleModels objectAtIndex:1];
                model.state = 1;
                model.name = [NSString stringWithFormat:@"2.已选择设备：%@", self.viewModel.selectedDeviceID];
                [self.listView reloadData];
                self.wifiListView.dataArr = [x copy];
                [self hideWifiList];
            }
            else
            {
                SettingModel *model = [self.viewModel.titleModels objectAtIndex:0];
                model.state = 1;
                model.name = [NSString stringWithFormat:@"1.已连接到设备热点：%@",self.viewModel.currentWifiName];
                [self.listView reloadData];
                self.wifiListView.lanDeviceDic = x;
            }
        }];
        self.wifiListView.refreshBtn.rac_command = self.viewModel.refreshCommand;
        self.wifiListView.selectDeviceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            [self.viewModel.selectDeviceCommand execute:input];
            return [RACSignal empty];
        }];
        self.wifiListView.selectWifiCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            [self.viewModel.setLanCommand execute:input];
            return [RACSignal empty];
        }];
        self.viewModel.nextStepSuccess = ^{
            @strongify(self);
            SettingModel *model = [self.viewModel.titleModels objectAtIndex:2];
            model.state = 1;
            model.name = [NSString stringWithFormat:@"3.已将设备连接到：%@",[[AppShare shareInstance] getCurrentWifiName]];
            [self.listView reloadData];
            [self hideWifiList];
            [self turnToWifiSetting];
        };
        [[self.wifiListView.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            @strongify(self);
            [self hideWifiList];
        }];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.titleModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRate(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
        UILabel *label = [UILabel new];
        [cell addSubview:label];
        label.tag = 100;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRate(20));
            make.top.bottom.equalTo(cell);
        }];
        UIImageView *arrowImageView = [UIImageView new];
        [cell addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kRate(20));
            make.centerY.equalTo(cell);
            make.width.mas_equalTo(kRate(8));
            make.height.mas_equalTo(kRate(15));
        }];
        arrowImageView.image = [UIImage imageNamed:@"arrow"];
    }
    UILabel *lab = [cell viewWithTag:100];
    SettingModel *model = [self.viewModel.titleModels objectAtIndex:indexPath.row];
    lab.text = model.name;
    lab.font = FONT(TF16);
    lab.textColor = model.state==0?CD_Text66:CD_Text;
    [cell drawBottomLine];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingModel *model = [self.viewModel.titleModels objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            if (!model.state) {
                [Utility showAlertWithMessage:[NSString stringWithFormat:@"请在iOS系统设置中，将网络连接到智能设备。 【设置】> 【无线局域网】"] delegate:self];
            }
        }
            break;
        case 1:
        {// 选择设备
            if (!model.state) {
                [self showWifiList];
            }
        }
            break;
        case 2:
        {// 重启设备
            if (!model.state) {
                [self showWifiList];
            }
        }
            break;
        default:
            break;
    }
}

- (void)showWifiList {
    [UIView animateWithDuration:0.25 animations:^{
        self.wifiListView.top = kScreenHeight - 300;
    }completion:nil];
}

- (void)hideWifiList {
    [UIView animateWithDuration:0.25 animations:^{
        self.wifiListView.top = kScreenHeight;
    }completion:nil];
}

- (void)cellDidselect:(id)wifiInfo {
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self turnToWifiSetting];
}

- (void)turnToWifiSetting {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
