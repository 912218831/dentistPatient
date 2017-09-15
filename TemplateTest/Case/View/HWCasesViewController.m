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
#import "CaseDetailViewModel.h"
#import "PopoverView.h"

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
    @weakify(self);
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
    self.listView.baseTable.backgroundColor = UIColorFromRGB(0xf0f0f0);
    headView.backgroundColor = CD_MainColor;
    self.segmentButton.backgroundColor = headView.backgroundColor;
    self.listView.top = headView.height;
    self.listView.height = self.view.height - 64 - 49 - headView.height;
    self.listView.cellHeight = ^(NSIndexPath *indexPath){
        return (CGFloat)kRate(111);
    };
    self.listView.didSelected = ^(NSIndexPath *indexPath){
        @strongify(self);
        CaseDetailViewModel *vm = [CaseDetailViewModel new];
        vm.caseModel = [self.viewModel.dataArray pObjectAtIndex:indexPath.row];
        [[ViewControllersRouter shareInstance]pushViewModel:vm animated:true];
    };
    self.segmentButton.titleLabel.text = @"儿子 - 小飞";
}

- (void)bindViewModel {
    [super bindViewModel];
    [self.viewModel bindViewWithSignal];
    
    @weakify(self);
    [[self.segmentButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        PopoverView *popoverView = [PopoverView popoverView];
        popoverView.arrowStyle = PopoverViewArrowStyleTriangle;
        [popoverView showToView:self.segmentButton withActions:[self QQActions]];
    }];
    
    [self.viewModel.requestSignal.newSwitchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.listView.baseTable reloadData];
        [self.listView doneLoadingTableViewData];
    } error:^(NSError *error) {
        [Utility showToastWithMessage:error.domain];
    } completed:nil];
    
    [self.viewModel execute];
}

- (NSArray<PopoverAction *> *)QQActions {
    // 发起多人聊天 action
    PopoverAction *multichatAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"right_menu_multichat"] title:@"父亲--默默" handler:^(PopoverAction *action) {
    }];
    // 加好友 action
    PopoverAction *addFriAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"right_menu_addFri"] title:@"母亲--大大" handler:^(PopoverAction *action) {
        
    }];
    // 扫一扫 action
    PopoverAction *QRAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"right_menu_QR"] title:@"老婆--晔晔" handler:^(PopoverAction *action) {
        
    }];
    
    return @[multichatAction, addFriAction, QRAction];
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
