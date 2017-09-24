//
//  RecommandDoctorVC.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "RecommandDoctorVC.h"
#import "MapView.h"
#import "RecommandDoctorViewModel.h"
#import "RDoctorListCell.h"
#import "DoctorDetailViewModel.h"

@interface RecommandDoctorVC ()
@property (nonatomic, strong) MapView *mapView;
@property (nonatomic, strong) RecommandDoctorViewModel *viewModel;
@end

@implementation RecommandDoctorVC
@dynamic viewModel;

- (void)configContentView {
    [super configContentView];
    
    self.listView.baseTable.height = self.listView.height = CONTENT_HEIGHT - self.listView.top;
    self.listView.isNeedHeadRefresh = false;
    self.listView.backgroundColor = [UIColor clearColor];
    self.listView.cellHeight = ^(NSIndexPath *indexPath){
        return indexPath.row==0?kRate(308):(CGFloat)kRate(108);
    };
    @weakify(self);
    self.listView.didSelected = ^(NSIndexPath *indexPath){
        @strongify(self);
        DoctorDetailViewModel *model = [DoctorDetailViewModel new];
        model.doctorModel = self.viewModel.dataArray[indexPath.row];
        model.checkId = self.viewModel.checkId;
        [[ViewControllersRouter shareInstance]pushViewModel:model animated:YES];
    };
    self.listView.baseTable.layer.masksToBounds = false;
}

- (void)bindViewModel {
    [super bindViewModel];
    [self.viewModel bindViewWithSignal];
    
    [Utility showMBProgress:self.contentView message:nil];
    @weakify(self);
    [self.viewModel.requestSignal.newSwitchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.listView.baseTable reloadData];
        [Utility hideMBProgress:self.contentView];
    } error:^(NSError *error) {
        @strongify(self);
        [Utility showToastWithMessage:error.domain];
        [Utility hideMBProgress:self.contentView];
    } completed:^{
        @strongify(self);
        [Utility hideMBProgress:self.contentView];
    }];
}

- (UITableViewCell *)tableViewCell:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MapView *cell = self.mapView;
        if (cell == nil) {
            cell = [[MapView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MapView class])];
            self.mapView = cell;
            RAC(self.viewModel, coordinate2D) = cell.locationSuccess;
            @weakify(self);
            [cell.locationFail subscribeNext:^(id x) {
                [Utility showToastWithMessage:[x domain]];
            }];
            [cell.locationSuccess subscribeNext:^(id x) {
                @strongify(self);
                [self.viewModel execute];
            }];
        }
        cell.valueSignal = [RACSignal return:RACTuplePack(self.viewModel.dataArray.firstObject, self.viewModel.annotations)];
        
        return cell;
    }
    RDoctorListCell *cell = [self.listView.baseTable dequeueReusableCellWithIdentifier:kRDoctorVM];
    if (cell == nil) {
        cell = [[RDoctorListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRDoctorVM];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.valueSignal = [RACSignal return:self.viewModel.dataArray[indexPath.row]];
    return cell;
}

- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
