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
        [Utility showToastWithMessage:error.domain];
        [Utility hideMBProgress:self.contentView];
    } completed:^{
        [Utility hideMBProgress:self.contentView];
    }];
    
    [self.viewModel execute];
}

- (UITableViewCell *)tableViewCell:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MapView *cell = self.mapView;
        if (cell == nil) {
            cell = [[MapView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MapView class])];
            self.mapView = cell;
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

- (void)backMethod {
    [super backMethod];
    UIView *wrapView = [self.listView.baseTable.subviews firstObject];
    NSLog(@"%@",wrapView.subviews);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
