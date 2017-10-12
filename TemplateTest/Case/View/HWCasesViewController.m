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

@interface HWCasesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) HWCasesViewModel *viewModel;
@property (nonatomic, strong) CaseSegmentButton *segmentButton;
@property (nonatomic, strong) RACSignal *createFooterSignal;
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
    UIView *headView = [[UIView alloc]initWithFrame:(CGRect){CGPointZero, self.view.width, kRate(50)}];
    [self addSubview:headView];
    self.segmentButton = [CaseSegmentButton new];
    [headView addSubview:self.segmentButton];
    //
    CGFloat sW = kRate(106);
    CGFloat sX = (headView.width - sW)/2.0;
    CGFloat sY = kRate(12);
    CGFloat sH = headView.height - 2*sY;
    self.segmentButton.frame = (CGRect){sX, sY, sW, sH};
    //
    self.listView = [[UITableView alloc]initWithFrame:CGRectMake(0, headView.height, self.view.width, self.view.height - 64 - kTabbarHeight - headView.height) style:UITableViewStylePlain];
    self.listView.dataSource = self;
    self.listView.delegate = self;
    self.listView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    headView.backgroundColor = COLOR_FFFFFF;
    [headView drawBottomLine];
    self.segmentButton.backgroundColor = headView.backgroundColor;
    [self addSubview:self.listView];
    
    self.segmentButton.title = @"全部";
    self.listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.currentPage = 1;
        [self.viewModel execute];
    }];
    
    self.createFooterSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        self.listView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.viewModel.currentPage += 1;
            [self.viewModel execute];
        }];
        return nil;
    }];
    
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
        } else {
            [self.viewModel.gainFamilyMember execute:nil];
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
        [self.listView reloadData];
    } error:^(NSError *error) {
        [Utility showToastWithMessage:error.domain];
    } completed:nil]finally:^{
        @strongify(self);
        [Utility hideMBProgress:self.contentView];
        [self.listView.mj_header endRefreshing];
        if (self.viewModel.isLastPage) {
            [self.listView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.listView.mj_footer endRefreshing];
        }
    }];
    
    [self.viewModel.gainFamilyMember.errors subscribeNext:^(id x) {
        [Utility showToastWithMessage:[x domain]];
    }];
    [self.viewModel.gainFamilyMember.executing subscribeNext:^(id x) {
        if ([x boolValue]) {
            [Utility showMBProgress:self.contentView message:nil];
        } else {
           [Utility hideMBProgress:self.contentView];
        }
    }];
    
    [[RACObserve(self.viewModel, familyMemberIndex)filter:^BOOL(id value) {
        return [value integerValue];
    }]subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.segmentButton.title = [[self.viewModel.familyMember objectAtIndex:x.integerValue-1]name];
        if (x.integerValue>0) {
            [Utility showMBProgress:self.contentView message:nil];
            self.viewModel.currentPage = 1;
            [self.viewModel execute];
        }
    }];
    [[[RACObserve(self.viewModel, allPage)distinctUntilChanged]filter:^BOOL(id value) {
        return [value integerValue];
    }]subscribeNext:^(id x) {
        @strongify(self);
        if ([x integerValue] > 1) {
            [self.createFooterSignal subscribe:[RACSubject subject]];
        }
    }];
    //
    [self.viewModel.gainFamilyMember execute:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (CGFloat)kRate(111);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"CaseListCell";
    CaseListCell *cell = [self.listView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[CaseListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] ;
    }
    cell.valueSignal = [RACSignal return:self.viewModel.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CaseDetailViewModel *vm = [CaseDetailViewModel new];
    vm.caseModel = [self.viewModel.dataArray pObjectAtIndex:indexPath.row];
    [[ViewControllersRouter shareInstance]pushViewModel:vm animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
