//
//  HWAppointmentViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//  预约

#import "HWAppointmentViewController.h"
#import "HWAppointmentFailViewController.h"
#import "HWAppointWaitingViewController.h"
#import "HWAppointSuccessViewController.h"
#import "HWAppointmentCell.h"
#import <MJRefresh/MJRefresh.h>
@interface HWAppointmentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(strong,nonatomic)UICollectionView * collectionView;
@property(strong,nonatomic,readonly)HWAppointmentViewModel * viewModel;
@property(strong,nonatomic)NSArray * dataArr;
@property(strong,nonatomic)RACDisposable * fetchDataDispose;
@end

@implementation HWAppointmentViewController
@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(HWTabBarViewController *)SHARED_APP_DELEGATE.viewController setTabBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [(HWTabBarViewController *)SHARED_APP_DELEGATE.viewController setTabBarHidden:YES animated:YES];
}


- (void)configContentView
{
    [super configContentView];
    self.dataArr = [NSArray array];
    [self.view addSubview:self.collectionView];
    @weakify(self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self fetchData];
    }];
}
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT - 49) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = COLOR_F0F0F0;
        [_collectionView registerNib:[UINib nibWithNibName:@"HWAppointmentCell" bundle:nil] forCellWithReuseIdentifier:@"HWAppointmentCell"];
    }
    return _collectionView;
}

#pragma UICollectionView datasource && delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-40)/2, 220);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 15, 15, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HWAppointmentCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HWAppointmentCell" forIndexPath:indexPath];
    cell.model = [self.dataArr pObjectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HWAppointListModel * model = [self.dataArr pObjectAtIndex:indexPath.row];
    [self.viewModel.itemClickCommand execute:model];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)bindViewModel
{
    [super bindViewModel];
    [self.viewModel bindViewWithSignal];
    [self fetchData];
    [self.viewModel execute];
    @weakify(self);
    [[RACObserve(self.viewModel, isNeedRefresh) filter:^BOOL(id value) {
        return (value == 0) ? NO:YES;
        
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self fetchData];
       
    }];
}

- (void)fetchData
{
    if (self.fetchDataDispose) {
        [self.fetchDataDispose dispose];
    }
    @weakify(self);
    self.fetchDataDispose = [[self.viewModel.requestSignal deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        if ([x isKindOfClass:[NSString class]]) {
            [Utility showMBProgress:self.view message:x];

        }
        else
        {
            [self.collectionView.mj_header endRefreshing];
            self.dataArr = [x copy];
            [Utility hideMBProgress:self.view];
            [self.collectionView reloadData];
        }
    } error:^(NSError *error) {
        @strongify(self);
        [Utility hideMBProgress:self.view];
        [Utility showToastWithMessage:error.localizedDescription];
        [self.collectionView.mj_header endRefreshing];
    }];
    
}

@end
