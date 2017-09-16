//
//  DetectionCaptureViewController.m
//  TemplateTest
//
//  Created by HW on 17/9/15.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "DetectionCaptureViewController.h"
#import "DetectionCaptureCell.h"
#import "HZPhotoBrowser.h"
#import "DetectionCaptureViewModel.h"
#import "TimeVideoViewModel.h"
#import "DetectionResultViewModel.h"

#define kOffX       (kRate(14))
#define kHeaderId    @"headerId"
#define kFooterId    @"footerId"
#define kCellId      @"cellId"

@interface DetectionCaptureViewController () <UICollectionViewDelegate,
                                            UICollectionViewDataSource,
                                            HZPhotoBrowserDelegate>
@property (nonatomic, strong) UICollectionView *listView;
@property (nonatomic, strong) DetectionCaptureViewModel *viewModel;
@property (nonatomic, strong) UIButton *nextStep;
@end

@implementation DetectionCaptureViewController
@dynamic viewModel;

- (void)configContentView {
    [super configContentView];
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.itemSize = CGSizeMake(kRate(116), kRate(116));
    flowLayout.minimumInteritemSpacing = kRate(3);
    flowLayout.minimumLineSpacing = kRate(3);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, kOffX, 0, kRate(6));
    flowLayout.headerReferenceSize = CGSizeMake(self.view.width, kRate(47));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.listView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.listView.delegate = self;
    self.listView.dataSource = self;
    self.listView.alwaysBounceVertical = true;
    self.listView.backgroundColor = COLOR_F0F0F0;
    [self addSubview:self.listView];
    [self.listView registerClass:[DetectionCaptureCell class] forCellWithReuseIdentifier:kCellId];
    [self.listView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderId];
    [self.listView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterId];
    
    self.nextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.nextStep];
    [self.nextStep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOffX);
        make.bottom.mas_equalTo(-kRate(21));
        make.right.mas_equalTo(-kOffX);
        make.height.mas_equalTo(kRate(50));
    }];
    [self.nextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextStep setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    self.nextStep.backgroundColor = CD_MainColor;
    self.nextStep.titleLabel.font = FONT(TF17);
}

- (void)bindViewModel {
    [super bindViewModel];
    [self.viewModel bindViewWithSignal];
    
    @weakify(self);
    [self.viewModel.requestSignal.newSwitchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.listView reloadData];
    }error:^(NSError *error) {
        
    } completed:^{
        
    }];
    [self.viewModel execute];
    
    [[self.nextStep rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        DetectionResultViewModel *vm = [DetectionResultViewModel new];
        [[ViewControllersRouter shareInstance]pushViewModel:vm animated:true];
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count+1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kFooterId forIndexPath:indexPath];
        return footerView;
    }
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderId forIndexPath:indexPath];
    UILabel *titleLabel = [headerView viewWithTag:100];
    if (titleLabel==nil) {
        titleLabel = [UILabel new];
        titleLabel.font = FONT(TF16);
        titleLabel.textColor = CD_Text66;
        titleLabel.tag = 100;
        [headerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kOffX);
            make.bottom.mas_equalTo(-kRate(11));
        }];
    }
    titleLabel.text = @"现在为儿子拍照";
    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DetectionCaptureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    if (indexPath.row < self.viewModel.dataArray.count) {
        cell.deleteBtn.hidden = false;
        cell.photoImageView.image = nil;
        cell.valueSignal = [RACSignal return:[self.viewModel.dataArray objectAtIndex:indexPath.row]];
        @weakify(self);
        [cell.deleteActionSubject subscribeNext:^(id x) {
            @strongify(self);
            NSLog(@"删除啦");
            // 删除
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.viewModel.dataArray.count > indexPath.row) {
                    [self.viewModel.dataArray removeObjectAtIndex:indexPath.row];
                }
                [self.listView reloadData];
            });
        }];
    } else {
        cell.deleteBtn.hidden = true;
        cell.photoImageView.image = nil;
    }
    
    cell.backgroundColor = self.listView.backgroundColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.viewModel.dataArray.count) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        //启动图片浏览器
        HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
        browser.sourceImagesContainerView = cell; // 原图的父控件
        browser.imageCount = self.viewModel.dataArray.count; // 图片总数
        browser.currentImageIndex = (int)indexPath.row;
        browser.delegate = self;
        [browser show];
    } else {
        // 拍照
        TimeVideoViewModel *vm = [TimeVideoViewModel new];
        [[ViewControllersRouter shareInstance]pushViewModel:vm animated:YES];
    }
    
}

- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    DetectionCaptureModel *model = [self.viewModel.dataArray objectAtIndex:index];
    UIImage *resultImage = [[SDImageCache sharedImageCache]imageFromMemoryCacheForKey:model.imgUrl];
    if (resultImage==nil) {
        resultImage = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:model.imgUrl];
    }
    return resultImage;
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    DetectionCaptureModel *model = [self.viewModel.dataArray objectAtIndex:index];
    return [NSURL URLWithString:model.imgUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
