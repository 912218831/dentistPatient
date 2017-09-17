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

@interface DoctorDetailViewController ()
@property (nonatomic, strong) DoctorDetailViewModel *viewModel;
@end

@implementation DoctorDetailViewController
@dynamic viewModel;

- (void)configContentView {
    [super configContentView];
    
    self.listView.isNeedHeadRefresh = false;
    @weakify(self);
    self.listView.cellHeight = ^(NSIndexPath *indexPath){
        @strongify(self);
        if (indexPath.row == 0) {
            return (CGFloat)kRate(325);
        }
        return (CGFloat)(self.viewModel.timesHeight+kRate(160)+kRate(272/2.0));
    };
}

- (void)bindViewModel {
    [super bindViewModel];
    [self.viewModel bindViewWithSignal];
    
    @weakify(self);
    [Utility showMBProgress:self.contentView message:nil];
    [[self.viewModel.requestSignal.newSwitchToLatest subscribeNext:^(id x) {
        [self.listView.baseTable reloadData];
    } error:^(NSError *error) {
        
    } completed:nil]finally:^{
        @strongify(self);
        [Utility hideMBProgress:self.contentView];
    }];
    
    [self.viewModel execute];
}

- (UITableViewCell *)tableViewCell:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        DoctorDetailInfoCell *cell = [[DoctorDetailInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DoctorDetailModel class])];
        return cell;
    } else {
        DoctorDetailDateMapCell *cell = [[DoctorDetailDateMapCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DoctorDetailTimeListModel class])];
        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
