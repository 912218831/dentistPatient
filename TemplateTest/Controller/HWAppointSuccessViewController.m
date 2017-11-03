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
#import "HWHomePageSecondHeader.h"
#import "HWAppointFinishViewModel.h"
@interface HWAppointSuccessViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate>

@property(strong,nonatomic)UICollectionView * collectionView;
@property(strong,nonatomic)HWAppointSuccessViewModel * viewModel;
@property(strong,nonatomic)UIButton * payBtn;
@property(strong,nonatomic)UIButton * answerBtn;
@property(strong,nonatomic)HWAppointCouponModel * selectCouponModel;
@property(strong,nonatomic)UIImageView * headerImgV;
@end

@implementation HWAppointSuccessViewController
@dynamic viewModel;

- (void)configContentView
{
    [super configContentView];
    [self.view addSubview:self.collectionView];
    self.payBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.collectionView.bottom, kScreenWidth, 50)];
    [self.payBtn setTitle:@"支付" forState:UIControlStateNormal];
    [self.payBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    self.payBtn.backgroundColor = COLOR_28BEFF;
    [self.view addSubview:self.payBtn];
    self.answerBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 0, 50, 32)];
    self.answerBtn.bottom = self.payBtn.top - 10;
    self.answerBtn.contentMode = UIViewContentModeCenter;
    [self.answerBtn setImage:ImgWithName(@"answer") forState:UIControlStateNormal];
    [self.view addSubview:self.answerBtn];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kWechatPayCallBack object:nil] subscribeNext:^(NSNotification * notify) {
        if ([notify.object isKindOfClass:[PayResp class]]) {
            PayResp * resq = notify.object;
            //支付返回结果，实际支付结果需要去微信服务器端查询
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [params setPObject:self.viewModel.orderCode forKey:@"orderCode"];
            HWHTTPSessionManger * manager = [HWHTTPSessionManger manager];
            [manager HWPOST:kPayCallBack parameters:params success:^(id responese) {
                HWAppointFinishViewModel * finishViewModel = [[HWAppointFinishViewModel alloc] initWithAppointId:self.viewModel.detailModel.appointId];
                [[ViewControllersRouter shareInstance] pushViewModel:finishViewModel animated:NO];
            } failure:^(NSString *code, NSString *error) {
                [Utility showToastWithMessage:error];
                [[ViewControllersRouter shareInstance] popViewModelAnimated:YES];
            }];

        }
    }];
    
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
        [_collectionView registerNib:[UINib nibWithNibName:@"HWHomePageSecondHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HWHomePageSecondHeader"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header01"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer01"];

        _collectionView.backgroundColor = COLOR_FFFFFF;
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT)];
        self.headerImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, kRate(117), kRate(150))];
        self.headerImgV.centerX = kScreenWidth/2.0f;
//        self.headerImgV.image = ImgWithName(@"我的预约bg");
        [bg addSubview:self.headerImgV];
        _collectionView.backgroundView = bg;
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return CGSizeMake(kScreenWidth, 40);
    }
    else
    {
        return CGSizeMake(kScreenWidth, kRate(168));
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return CGSizeMake(kScreenWidth, 20);
    }
    else
    {
        return CGSizeZero;
    }
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 1) {
            HWHomePageSecondHeader * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HWHomePageSecondHeader" forIndexPath:indexPath];
            header.title = @"可用优惠券";
            return header;
            
        }
        else if (indexPath.section == 0)
        {
            UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header01" forIndexPath:indexPath];
            header.backgroundColor = [UIColor clearColor];
            return header;
        }
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        if (indexPath.section == 1) {
            UICollectionReusableView * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer01" forIndexPath:indexPath];
            footer.backgroundColor = [UIColor clearColor];
            return footer;
        }
        else
        {
            return nil;
        }
    }
    return nil;
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

    [[self.viewModel.requestSignal deliverOnMainThread]subscribeNext:^(NSString * x) {
        @strongify(self);
        [Utility showMBProgress:self.view message:x];
    } error:^(NSError *error) {
        @strongify(self);
        [Utility hideMBProgress:self.view];
        [Utility showToastWithMessage:error.localizedDescription];
    } completed:^{
        @strongify(self);
        [Utility hideMBProgress:self.view];
        [self.collectionView reloadData];
        [self.headerImgV sd_setImageWithURL:[NSURL URLWithString:self.viewModel.detailModel.headImgUrl] placeholderImage:ImgWithName(@"我的预约bg")];

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
                    @weakify(self);
                    [[AlipaySDK defaultService] payOrder:x fromScheme:kAliPay callback:^(NSDictionary *resultDic) {
                        @strongify(self);
                        
                        self.viewModel.payState = [resultDic objectForKey:@"resultStatus"];
//                        if([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"6001"] || [[resultDic objectForKey:@"resultStatus"] isEqualToString:@"6002"])
//                        {
//                            //6001用户取消 6002网络错误 可以重新支付
//
//                        }
//                        else
//                        {
                            NSMutableDictionary * params = [NSMutableDictionary dictionary];
                            [params setPObject:self.viewModel.orderCode forKey:@"orderCode"];
                            if([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"])
                            {
                                //支付成功
                                [params setPObject:@"1" forKey:@"state"];
                                [Utility showToastWithMessage:@"支付成功"];

                            }
                            else
                            {
                                //支付失败
                                [params setPObject:@"2" forKey:@"state"];

                            }
                            HWHTTPSessionManger * manager = [HWHTTPSessionManger manager];
                            [manager HWPOST:kPayCallBack parameters:params success:^(id responese) {
                                HWAppointFinishViewModel * finishViewModel = [[HWAppointFinishViewModel alloc] initWithAppointId:self.viewModel.detailModel.appointId];
                                [[ViewControllersRouter shareInstance] pushViewModel:finishViewModel animated:NO];
                            } failure:^(NSString *code, NSString *error) {
                                [Utility showToastWithMessage:error];
                                [[ViewControllersRouter shareInstance] popViewModelAnimated:YES];
                            }];
//                        }
                    }];

                } error:^(NSError *error) {
                    [Utility showToastWithMessage:error.localizedDescription];
                }];
            }
            if (x.integerValue == 1) {
                //微信
                [[[self.viewModel.payCommand execute:x] deliverOnMainThread] subscribeNext:^(id x) {
                    
                    if ([x isKindOfClass:[NSDictionary class]]) {
                        NSDictionary * dict = [x copy];
                        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                        PayReq* req             = [[PayReq alloc] init];
                        req.partnerId           = [dict objectForKey:@"partnerid"];
                        req.prepayId            = [dict objectForKey:@"prepayid"];
                        req.nonceStr            = [dict objectForKey:@"noncestr"];
                        req.timeStamp           = stamp.intValue;
                        req.package             = [dict objectForKey:@"packageCode"];
                        req.sign                = [dict objectForKey:@"sign"];
                        [WXApi sendReq:req];
                        NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );

                    }
                    else
                    {
                        return;
                    }
                    
                } error:^(NSError *error) {
                    [Utility showToastWithMessage:error.localizedDescription];

                }];
            }
            
        }];
        [actionSheet showInView:SHARED_APP_DELEGATE.window];
    }];
    
    RAC(self.viewModel,selectCoupontModel) = RACObserve(self, selectCouponModel);
    self.answerBtn.rac_command = self.viewModel.answerCommand;
}




@end
