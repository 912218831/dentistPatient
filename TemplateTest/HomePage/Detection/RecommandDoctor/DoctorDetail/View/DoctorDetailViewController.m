//
//  DoctorDetailViewController.m
//  TemplateTest
//
//  Created by HW on 17/9/17.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DoctorDetailViewController.h"
#import "DoctorDetailViewModel.h"
#import "DoctorDetailInfoCell.h"
#import "DoctorDetailDateMapCell.h"
#import "BaseWebViewModel.h"

@interface DoctorDetailViewController ()
@property (nonatomic, strong) DoctorDetailViewModel *viewModel;
@property (nonatomic, strong) UIButton *orderBtn;
@end

@implementation DoctorDetailViewController
@dynamic viewModel;

- (void)configContentView {
    [super configContentView];
    
    @weakify(self);
    self.listView.height -= kRate(50);
//    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.listView.width, kRate(60))];
//    self.listView.baseTable.tableFooterView = footerView;
    
    self.orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.orderBtn];
    
    self.orderBtn.frame = CGRectMake(0, self.contentView.height-kRate(50), self.contentView.width, kRate(50));
    
    self.orderBtn.backgroundColor = CD_MainColor;
    self.orderBtn.titleLabel.font = FONT(TF17);
    [self.orderBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    [self.orderBtn setTitle:@"预约" forState:UIControlStateNormal];
}

- (void)bindViewModel {
    [super bindViewModel];
    [self.viewModel bindViewWithSignal];
    
    @weakify(self);
    [Utility showMBProgress:self.contentView message:nil];
    [[self.viewModel.requestSignal.newSwitchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.listView reloadData];
    } error:^(NSError *error) {
        
    } completed:nil]finally:^{
        @strongify(self);
        [Utility hideMBProgress:self.contentView];
    }];
    
    [self.viewModel execute];

    [[self.orderBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
      // 预约
        @strongify(self);
        NSLog(@"预约==row=%ld, col=%ld",self.viewModel.selectDateIndexPath.row,self.viewModel.selectDateIndexPath.section);
        [Utility showMBProgress:self.contentView message:nil];
        [[self.viewModel.orderSignal.newSwitchToLatest subscribeNext:nil error:^(NSError *error) {
            [Utility showToastWithMessage:error.domain];
        } completed:^{
            [Utility showToastWithMessage:@"预约成功" complete:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshReservedList object:nil];
                [[ViewControllersRouter shareInstance]popToRootViewModelAnimated:false];
                [(HWTabBarViewController*)SHARED_APP_DELEGATE.viewController setSelectedIndex:2];
            }];
        }]finally:^{
            [Utility hideMBProgress:self.contentView];
        }];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return (CGFloat)kRate(266);
    }
    return (CGFloat)(self.viewModel.timesHeight+kRate(160));
}

- (UITableViewCell *)tableViewCell:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        DoctorDetailInfoCell *cell = [[DoctorDetailInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DoctorDetailModel class])];
        cell.valueSignal = [RACSignal return:self.viewModel.dataArray.firstObject];
        return cell;
    } else {
        DoctorDetailDateMapCell *cell = [[DoctorDetailDateMapCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DoctorDetailTimeListModel class])];
        cell.valueSignal = [RACSignal return:self.viewModel.annotation];
        cell.datesSignal = [RACSignal return:[RACTuple tupleWithObjectsFromArray:self.viewModel.dataArray.lastObject]];
        @weakify(self);
        [cell.dateView.didSelectDateSiganl subscribeNext:^(id x) {
            @strongify(self);
            self.viewModel.selectDateIndexPath = x;
        }];
        [cell drawBottomLine];
        return cell;
    }
}

- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
