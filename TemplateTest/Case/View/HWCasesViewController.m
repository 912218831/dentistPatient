//
//  HWCasesViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
// 病例

#import "HWCasesViewController.h"
#import "HWCasesViewModel.h"
#import "CaseSegmentButton.h"
#import "CaseListCell.h"

@interface HWCasesViewController ()
@property (nonatomic, strong) HWCasesViewModel *viewModel;
@property (nonatomic, strong) CaseSegmentButton *segmentButton;
@end

@implementation HWCasesViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configContentView {
    [super configContentView];
    UIImage *shadowImage = [Utility imageWithColor:[UIColor clearColor] andSize:CGSizeMake(1, 1)];
    [[self rac_signalForSelector:@selector(viewWillAppear:)]subscribeNext:^(id x) {
        [self.navigationController.navigationBar setShadowImage:shadowImage];
    }];
    //
    UIView *headView = [[UIView alloc]initWithFrame:(CGRect){CGPointZero, self.view.width, kRate(36)}];
    [self addSubview:headView];
    self.segmentButton = [CaseSegmentButton new];
    [headView addSubview:self.segmentButton];
    //
    [self.segmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headView);
        make.width.mas_equalTo(kRate(106));
        make.bottom.equalTo(headView).with.offset(-kRate(14));
        make.top.equalTo(headView).with.offset(kRate(8));
    }];
    //
    self.contentView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    headView.backgroundColor = CD_MainColor;
    self.segmentButton.backgroundColor = headView.backgroundColor;
    self.listView.top = headView.height;
    self.listView.height = self.view.height - 64 - 49 - headView.height;
    self.listView.cellHeight = ^(NSIndexPath *indexPath){
        return (CGFloat)kRate(111);
    };
    self.segmentButton.titleLabel.text = @"儿子 - 小飞";
}

- (void)bindViewModel {
    [super bindViewModel];
    [self.viewModel bindViewWithSignal];
    
    @weakify(self);
    [self.viewModel.requestSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.listView.baseTable reloadData];
        [self.listView doneLoadingTableViewData];
    }];
    
    self.viewModel.active = true;
}

- (UITableViewCell *)tableViewCell:(NSIndexPath *)indexPath {
    NSString *cellId = @"CaseListCell";
    CaseListCell *cell = [self.listView.baseTable dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[CaseListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] ;
    }
    cell.valueSignal = [RACSignal return:self.viewModel.dataArray[indexPath.row]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
