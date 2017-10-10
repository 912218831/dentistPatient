//
//  HWAppointSuccessViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/14.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWAppointSuccessViewController.h"
#import "HWAppointSuccessViewModel.h"
#import "HWAppointSuccessCell.h"
#import "HWAppointCouponModel.h"
#import "HWAppointCouponCell.h"
#import <AlipaySDK/AlipaySDK.h>

@interface HWAppointSuccessViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate>

@property(strong,nonatomic)UICollectionView * collectionView;
@property(strong,nonatomic)HWAppointSuccessViewModel * viewModel;
@property(strong,nonatomic)UIButton * payBtn;
@property(strong,nonatomic)HWAppointCouponModel * selectCouponModel;
@end

@implementation HWAppointSuccessViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.payBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.collectionView.bottom, kScreenWidth, 50)];
    [self.payBtn setTitle:@"支付" forState:UIControlStateNormal];
    [self.payBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    self.payBtn.backgroundColor = COLOR_28BEFF;
    [self.view addSubview:self.payBtn];

}

- (UICollectionView *)collectionView
{
    if(_collectionView == nil)
    {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT-50) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"HWAppointSuccessCell" bundle:nil] forCellWithReuseIdentifier:@"HWAppointSuccessCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"HWAppointCouponCell" bundle:nil] forCellWithReuseIdentifier:@"HWAppointCouponCell"];
        _collectionView.backgroundColor = COLOR_FFFFFF;
    }
    return _collectionView;
}


#pragma UICollectionView delegate && datasource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth, 217);

    }
    else if(indexPath.section == 1)
    {
        return CGSizeMake((kScreenWidth - 60 - 20)/3, 70);
    }
    return CGSizeZero;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return UIEdgeInsetsMake(0, 30, 0, 30);
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return 15;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return 10;

    }
    else
    {
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if(section == 1)
    {
        return self.viewModel.coupons.count;
    }
    else
    {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HWAppointSuccessCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HWAppointSuccessCell" forIndexPath:indexPath];
        [cell bindViewModel:self.viewModel];
        RAC(self.viewModel,sumMoney) = [cell.moneyTF.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
        return cell;

    }
    else if(indexPath.section == 1)
    {
        HWAppointCouponCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HWAppointCouponCell" forIndexPath:indexPath];
        [cell bindViewModel:[self.viewModel.coupons pObjectAtIndex:indexPath.row]];
        return cell;
    }
    else
    {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSInteger selectModelRow;
        NSInteger currentModelRow;
        if (self.selectCouponModel) {
            selectModelRow = [self.viewModel.coupons indexOfObject:self.selectCouponModel];
        }
        currentModelRow = indexPath.row;
        HWAppointCouponModel * model = [self.viewModel.coupons pObjectAtIndex:currentModelRow];
        model.selected = !model.selected;
        if ((selectModelRow != currentModelRow) && self.selectCouponModel) {
            self.selectCouponModel.selected = NO;
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath,[NSIndexPath indexPathForItem:selectModelRow inSection:1]]];
        }
        else
        {
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
        self.selectCouponModel = model;
    }
}

- (void)bindViewModel
{
    [super bindViewModel];
    [self.viewModel initRequestSignal];
    @weakify(self);
    [self.viewModel.requestSignal subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    } error:^(NSError *error) {
        [Utility showToastWithMessage:error.localizedDescription];
    }];
    [self.viewModel execute];
    
    [[self.payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.viewModel.sumMoney.length == 0) {
            [Utility showToastWithMessage:@"请输入金额"];
            return;
        }
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
        [actionSheet.rac_buttonClickedSignal subscribeNext:^(NSNumber * x) {
            @strongify(self);
            if (x.integerValue == 0) {
                //支付宝
                [[[self.viewModel.payCommand execute:x] deliverOnMainThread] subscribeNext:^(NSString * x) {
                    [[AlipaySDK defaultService] payOrder:x fromScheme:kAliPay callback:^(NSDictionary *resultDic) {
                        
                        
                    }];

                } error:^(NSError *error) {
                    [Utility showToastWithMessage:error.localizedDescription];
                }];
            }
            if (x.integerValue == 1) {
                //微信
                [[[self.viewModel.payCommand execute:x] deliverOnMainThread] subscribeNext:^(id x) {
                    
                } error:^(NSError *error) {
                    [Utility showToastWithMessage:error.localizedDescription];

                }];
            }
            
        }];
        [actionSheet showInView:SHARED_APP_DELEGATE.window];
    }];
    
    
    RAC(self.viewModel,selectCoupontModel) = RACObserve(self, selectCouponModel);
}



@end
