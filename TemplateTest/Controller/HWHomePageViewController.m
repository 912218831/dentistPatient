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
@interface HWHomePageViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property(strong,nonatomic)UIView * nav;
@property(strong,nonatomic)UIButton * changeCityBtn;
@property(strong,nonatomic)UIButton * searchBtn;
@property(strong,nonatomic)UICollectionView  * collectionView;
@end

@implementation HWHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self.view addSubview:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, CONTENT_HEIGHT) collectionViewLayout:[[HWHomePageLayout alloc] init]];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
        
        
    }
    return _collectionView;
}

#pragma CollectionDelegate && datasource



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
