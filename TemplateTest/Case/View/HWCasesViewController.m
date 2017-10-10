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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(HWTabBarViewController *)SHARED_APP_DELEGATE.viewController setTabBarHidden:NO animated:YES];
}

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
        make.bottom.equalTo(headView).with.offset(-kRate(12));
        make.top.equalTo(headView).with.offset(kRate(4));
    }];
    //
    self.listView.baseTable.backgroundColor = UIColorFromRGB(0xf0f0f0);
    headView.backgroundColor = CD_MainColor;
    self.segmentButton.backgroundColor = headView.backgroundColor;
    self.listView.top = headView.height;
    self.listView.height = self.view.height - 64 - kTabbarHeight - headView.height;
    self.listView.cellHeight = ^(NSIndexPath *indexPath){
        return (CGFloat)kRate(111);
    };
    self.listView.didSelected = ^(NSIndexPath *indexPath){
        @strongify(self);
        CaseDetailViewModel *vm = [CaseDetailViewModel new];
        vm.caseModel = [self.viewModel.dataArray pObjectAtIndex:indexPath.row];
        [[ViewControllersRouter shareInstance]pushViewModel:vm animated:true];
    };
    self.segmentButton.title = @"";
    
}

- (void)bindViewModel {
    [super bindViewModel];
    [self.viewModel bindViewWithSignal];
    
    @weakify(self);
    [[self.segmentButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        PopoverView *popoverView = nil;
        if (self.viewModel.familyMember.count) {
            popoverView = [PopoverView popoverView];
            popoverView.arrowStyle = PopoverViewArrowStyleTriangle;
        }
        NSMutableArray *actions = [NSMutableArray arrayWithCapacity:self.viewModel.familyMember.count];
        for (FamilyMemberModel *model in self.viewModel.familyMember) {
            PopoverAction *action = [PopoverAction actionWithImage:[UIImage imageNamed:@"right_menu_multichat"] title:model.name handler:^(PopoverAction *action) {
                self.viewModel.familyMemberIndex = [actions indexOfObject:action]+1;
            }];
            [actions addObject:action];
        }
        [popoverView showToView:self.segmentButton withActions:actions];
    }];
    
    [[self.viewModel.requestSignal.newSwitchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.listView.baseTable reloadData];
        [self.listView doneLoadingTableViewData];
    } error:^(NSError *error) {
        [Utility showToastWithMessage:error.domain];
    } completed:nil]finally:^{
        [Utility hideMBProgress:self.contentView];
    }];
    
    [Utility showMBProgress:self.contentView message:nil];
    [[self.viewModel.gainFamilyMember execute:nil]subscribeNext:^(id x) {
        //@strongify(self);
        //[self.viewModel execute];
    } error:^(NSError *error) {
        [Utility showToastWithMessage:error.domain];
    }completed:^{
        //[Utility hideMBProgress:self.contentView];
    }];
    
    [RACObserve(self.viewModel, familyMemberIndex)subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.segmentButton.title = [[self.viewModel.familyMember objectAtIndex:x.integerValue-1]name];
        if (x.integerValue>0) {
            [Utility showMBProgress:self.contentView message:nil];
            self.viewModel.currentPage = 1;
            [self.viewModel execute];
        }
    }];
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
