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
@interface HWHomePageViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property(strong,nonatomic)UIView * nav;
@property(strong,nonatomic)UIButton * changeCityBtn;
@property(strong,nonatomic)UIButton * searchBtn;
@property(strong,nonatomic)UICollectionView  * collectionView;
@property(strong,nonatomic,readonly)HWHomePageViewModel * viewModel;

@end

@implementation HWHomePageViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self.view addSubview:self.collectionView];
    [self.viewModel execute];
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
    
    UIImage * cityImg = [HWCustomDrawImg drawAutoSizeTextAndImg:[UIImage imageNamed:@"arrow_down"] text:@"北京" grap:5 strconfig:@{NSForegroundColorAttributeName:COLOR_FFFFFF,NSFontAttributeName:FONT(15.0f)} strContainerSize:CGSizeZero imgPosition:HWCustomDrawRight];

    self.changeCityBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, cityImg.size.width, 44)];
    [self.nav addSubview:self.changeCityBtn];
    [self.changeCityBtn setImage:cityImg forState:UIControlStateNormal];
    self.changeCityBtn.contentMode = UIViewContentModeCenter;
    
    UIView * searchView = [[UIView alloc] initWithFrame:CGRectMake(self.changeCityBtn.right+15, 20, kScreenWidth - 45 - self.changeCityBtn.width, 28)];
    searchView.centerY = self.changeCityBtn.centerY;
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = 14.0f;
    searchView.layer.masksToBounds = YES;
    [self.nav addSubview:searchView];
    self.searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, searchView.width - 30, 28)];
    [searchView addSubview:self.searchBtn];
    UIImage * searchImg = [HWCustomDrawImg drawAutoSizeTextAndImg:[UIImage imageNamed:@"搜索"] text:@"附近的口腔医生" grap:10 strconfig:@{NSForegroundColorAttributeName:COLOR_999999,NSFontAttributeName:FONT(13)} strContainerSize:CGSizeZero imgPosition:HWCustomDrawLeft];
    self.searchBtn.contentMode = UIViewContentModeLeft;
    [self.searchBtn setImage:searchImg forState:UIControlStateNormal];
    
    
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
        _collectionView.backgroundColor = COLOR_FFFFFF;
        
    }
    return _collectionView;
}

#pragma CollectionDelegate && datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return self.viewModel.pushitems.count;
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
    else
    {
        return CGSizeMake((kScreenWidth-40)/2, 115);
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
        return UIEdgeInsetsMake(10, 15, 15, 10);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HWHomePageFuncBtnCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HWHomePageFuncBtnCell" forIndexPath:indexPath];
        cell.funcBtnClickCommand = self.viewModel.funcBtnCommand;
        return cell;

    }
    else
    {
        HWHomePageSecondCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HWHomePageSecondCell" forIndexPath:indexPath];
        cell.model = [self.viewModel.pushitems pObjectAtIndex:indexPath.row];
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
            return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HWHomePageSecondHeader" forIndexPath:indexPath];

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
    [[self.viewModel.requestSignal deliverOnMainThread] subscribeNext:^(id x) {
        [self.collectionView reloadData];

    } error:^(NSError *error) {
        [Utility showToastWithMessage:error.localizedDescription];
    }];
    self.changeCityBtn.rac_command = self.viewModel.selectCityCommand;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
