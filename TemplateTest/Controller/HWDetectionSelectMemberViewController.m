//
//  HWDetectionSelectMemberViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/14.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWDetectionSelectMemberViewController.h"
#import "HWDetectionSelectMemberViewModel.h"
#import "HWDecetionSelectMemberCell.h"
@interface HWDetectionSelectMemberViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(strong, nonatomic)UICollectionView * collectionView;
@property(nonatomic, strong)HWDetectionSelectMemberViewModel *viewModel;
@property(nonatomic, strong)UIAlertController *alertController;
@end

@implementation HWDetectionSelectMemberViewController
@dynamic viewModel;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)backMethod {
    [super backMethod];
    [self.navigationController setNavigationBarHidden:true];
}

- (void)configContentView {
    [super configContentView];
    
    [self.navigationController setNavigationBarHidden:false];
    [self addSubview:self.collectionView];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil
        preferredStyle:UIAlertControllerStyleActionSheet];
    
    @weakify(self);
    UIAlertAction *detectAction = [UIAlertAction actionWithTitle:@"牙龈检测" style:UIAlertActionStyleDefault handler:^ (UIAlertAction *action){
        @strongify(self);
        if (self.viewModel.detectActionBlock) {
            self.viewModel.detectActionBlock();
        }
    }];
    [alertController addAction:detectAction];
    
    UIAlertAction *recordAction = [UIAlertAction actionWithTitle:@"仅记录" style:UIAlertActionStyleDefault handler:^ (UIAlertAction *action){
        @strongify(self);
    }];
    [alertController addAction:recordAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    [detectAction setValue:UIColorFromRGB(0x474747) forKey:@"titleTextColor"];
    [recordAction setValue:UIColorFromRGB(0x474747) forKey:@"titleTextColor"];
    [cancelAction setValue:UIColorFromRGB(0x474747) forKey:@"titleTextColor"];
    
    self.alertController = alertController;
}

- (void)bindViewModel {
    [super bindViewModel];
    [self.viewModel bindViewWithSignal];
    @weakify(self);
    [Utility showMBProgress:self.contentView message:nil];
    [[self.viewModel.requestSignal.newSwitchToLatest subscribeNext:nil error:^(NSError *error) {
        [Utility showToastWithMessage:error.domain];
    } completed:^{
        @strongify(self);
        [self.collectionView reloadData];
    }]finally:^{
        @strongify(self);
        [Utility hideMBProgress:self.contentView];
    }];
    [self.viewModel execute];
    
    [self.viewModel.createCaseSignal.newSwitchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [Utility showMBProgress:self.contentView message:nil];
    } error:^(NSError *error) {
        @strongify(self);
        [Utility showToastWithMessage:error.domain];
        [Utility hideMBProgress:self.contentView];
    } completed:^{
        @strongify(self);
        [Utility hideMBProgress:self.contentView];
    }];
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = COLOR_F0F0F0;
        _collectionView.alwaysBounceVertical = true;
        [_collectionView registerNib:[UINib nibWithNibName:@"HWDecetionSelectMemberCell" bundle:nil] forCellWithReuseIdentifier:@"HWDecetionSelectMemberCell"];
        
    }
    return _collectionView;
}

#pragma UICollection delegate  && datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 50)/3, 120);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(35, 15, 35, 15);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HWDecetionSelectMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HWDecetionSelectMemberCell" forIndexPath:indexPath];
    cell.model = self.viewModel.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.viewModel.selectIndexPath = indexPath;
    [self presentViewController:self.alertController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

@end
