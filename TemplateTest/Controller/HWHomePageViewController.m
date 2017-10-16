//
//  HWHomePageViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
// 首页

#import "HWHomePageViewController.h"
#import "HWCustomDrawImg.h"
#import "HWHomePageLayout.h"
#import "HWHomePageHeader.h"
#import "HWHomePageFuncBtnCell.h"
#import "HWHomePageSecondHeader.h"
#import "HWHomePageSecondCell.h"
#import "HWHomePageLastRecordCell.h"
@interface HWHomePageViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property(strong,nonatomic)UIView * nav;
@property(strong,nonatomic)UIButton * changeCityBtn;
@property(strong,nonatomic)UIButton * searchBtn;
@property(strong,nonatomic)UICollectionView  * collectionView;
@property(strong,nonatomic,readonly)HWHomePageViewModel * viewModel;
@property(strong,nonatomic)UIView * searchView;
@property(strong,nonatomic)AFNetworkReachabilityManager * netWorkManager;
@end

@implementation HWHomePageViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self.view addSubview:self.collectionView];
    [self.viewModel execute];
    self.netWorkManager = [AFNetworkReachabilityManager managerForDomain:@"www.baidu.com"];
    [self.netWorkManager startMonitoring];
    [self.netWorkManager  setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可用");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"无线网络");
                [self fetchData];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"4g");
                [self fetchData];
                break;
            default:
                break;
        }
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
}

- (void)configNavigationBar
{
    self.nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.nav.backgroundColor = COLOR_28BEFF;
    [self.view addSubview:self.nav];
    self.changeCityBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.nav addSubview:self.changeCityBtn];
    self.changeCityBtn.contentMode = UIViewContentModeCenter;
    
    self.searchView = [[UIView alloc] initWithFrame:CGRectZero];
    self.searchView.backgroundColor = [UIColor whiteColor];
    self.searchView.layer.cornerRadius = 14.0f;
    self.searchView.layer.masksToBounds = YES;
    [self.nav addSubview:self.searchView];
    self.searchBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.searchView addSubview:self.searchBtn];
    [self changeCity];
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, CONTENT_HEIGHT - 49) collectionViewLayout:[[HWHomePageLayout alloc] init]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[HWHomePageHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader"];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"HWHomePageSecondHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HWHomePageSecondHeader"];
        
        [_collectionView registerClass:[HWHomePageFuncBtnCell class] forCellWithReuseIdentifier:@"HWHomePageFuncBtnCell"];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"HWHomePageSecondCell" bundle:nil] forCellWithReuseIdentifier:@"HWHomePageSecondCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"HWHomePageLastRecordCell" bundle:nil] forCellWithReuseIdentifier:@"HWHomePageLastRecordCell"];
        _collectionView.backgroundColor = COLOR_FFFFFF;
        
    }
    return _collectionView;
}

#pragma CollectionDelegate && datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if(section == 1)
    {
        return self.viewModel.pushitems.count;
    }
    else
    {
        return self.viewModel.lastRecords.count;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(kScreenWidth, kRate(180));
    }
    else
    {
        return CGSizeMake(kScreenWidth, 40);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth, 90);
    }
    else if(indexPath.section == 1)
    {
        return CGSizeMake((kScreenWidth-40)/2, 115);
    }
    else
    {
        return CGSizeMake((kScreenWidth - 30), 60);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsZero;
    }
    else
    {
        
        return UIEdgeInsetsMake(10, 15, 10, 15);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HWHomePageFuncBtnCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HWHomePageFuncBtnCell" forIndexPath:indexPath];
        cell.funcBtnClickCommand = self.viewModel.funcBtnCommand;
        return cell;

    }
    else if(indexPath.section == 1)
    {
        HWHomePageSecondCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HWHomePageSecondCell" forIndexPath:indexPath];
        cell.model = [self.viewModel.pushitems pObjectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        HWHomePageLastRecordCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HWHomePageLastRecordCell" forIndexPath:indexPath];
        cell.model = [self.viewModel.lastRecords pObjectAtIndex:indexPath.row];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            HWHomePageHeader * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader" forIndexPath:indexPath];
            header.dataArr = [self.viewModel.bannerModels copy];
            header.itemClickCommand = self.viewModel.bannerCommand;
            return header;

        }
        else
        {
            HWHomePageSecondHeader * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HWHomePageSecondHeader" forIndexPath:indexPath];
            if (indexPath.section == 2) {
                header.title = @"最近记录";
            }
            else
            {
                header.title = @"为你推荐";
            }
            return header;

        }
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel.pushItemCommand execute:indexPath];
}

#pragma bindModel

- (void)bindViewModel
{
    [super bindViewModel];
    [self.viewModel bindViewWithSignal];
    @weakify(self);
//    [self fetchData];
    self.changeCityBtn.rac_command = self.viewModel.selectCityCommand;
    self.searchBtn.rac_command = self.viewModel.searchDocCommand;
    [RACObserve([HWUserLogin currentUserLogin], cityName) subscribeNext:^(id x) {
        @strongify(self);
        [self changeCity];
    }];
}

- (void)fetchData{
    @weakify(self);
    [[self.viewModel.requestSignal deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
        
    } error:^(NSError *error) {
        [Utility showToastWithMessage:error.localizedDescription];
    }];

}

- (void)changeCity{
    UIImage * cityImg = [HWCustomDrawImg drawAutoSizeTextAndImg:[UIImage imageNamed:@"arrow_down"] text:[HWUserLogin currentUserLogin].cityName grap:5 strconfig:@{NSForegroundColorAttributeName:COLOR_FFFFFF,NSFontAttributeName:FONT(15.0f)} strContainerSize:CGSizeZero imgPosition:HWCustomDrawRight];
    self.changeCityBtn.frame = CGRectMake(15, 20, cityImg.size.width, 44);
    [self.changeCityBtn setImage:cityImg forState:UIControlStateNormal];
    self.searchView.frame = CGRectMake(self.changeCityBtn.right+15, 20, kScreenWidth - 45 - self.changeCityBtn.width, 28);
    self.searchView.centerY = self.changeCityBtn.centerY;
    self.searchBtn.frame = CGRectMake(15, 0, self.searchView.width - 30, 28);
    UIImage * searchImg = [HWCustomDrawImg drawAutoSizeTextAndImg:[UIImage imageNamed:@"搜索"] text:@"附近的口腔医生" grap:10 strconfig:@{NSForegroundColorAttributeName:COLOR_999999,NSFontAttributeName:FONT(13)} strContainerSize:CGSizeZero imgPosition:HWCustomDrawLeft];
    self.searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -(self.searchBtn.width-searchImg.width)/2.0f, 0, 0);
    [self.searchBtn setImage:searchImg forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
