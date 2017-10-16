//
//  HWHomePageHeader.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWHomePageHeader.h"
#import "HWHomePageBannerModel.h"
@interface HWHomePageHeader()<iCarouselDelegate,iCarouselDataSource>
{
    NSInteger _currentIndex;
}
@property(strong,nonatomic)iCarousel * bannerView;
@property(strong,nonatomic)UIPageControl * pageControl;
@end

@implementation HWHomePageHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArr = [NSArray array];
        [self addSubview:self.bannerView];
        [self addSubview:self.pageControl];
        self.backgroundColor = COLOR_F0F0F0;
        _currentIndex = 0;
        [[RACSignal interval:2.0f onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            if (_currentIndex >= self.dataArr.count)
            {
                _currentIndex = 0;
            }
            [_bannerView scrollToItemAtIndex:_currentIndex animated:YES];
            _currentIndex++;
        }];
    }
    return self;
}

- (iCarousel *)bannerView
{
    if (_bannerView == nil) {
        _bannerView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, kRate(150))];
        _bannerView.delegate = self;
        _bannerView.dataSource = self;
        _bannerView.type = iCarouselTypeCustom;
        _bannerView.pagingEnabled = YES;
        _bannerView.backgroundColor = COLOR_F0F0F0;
    }
    return _bannerView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.bannerView.bottom, _bannerView.width, kRate(20))];
//        _pageControl.center = CGPointMake(kScreenWidth / 2.0f, _bannerView.bottom + kRate(10));
        _pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xff6800);
        _pageControl.pageIndicatorTintColor = UIColorFromRGB(0xd5d5d7);
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.numberOfPages = self.dataArr.count;
    }
    return _pageControl;
}

#pragma icarousel delegate && datasource

- (NSInteger)numberOfItemsInCarousel:(iCarousel * __nonnull)carousel
{
    return self.dataArr.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 60, kRate(150))];
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 60, kRate(150))];
//        imgV.tag = 1001;
        [view addSubview:imgV];
        HWHomePageBannerModel * model = [self.dataArr pObjectAtIndex:index];
        [imgV sd_setImageWithURL:[NSURL URLWithString:model.imageurl] placeholderImage:placeHoderImg];
        view.layer.cornerRadius = 3.0f;
        view.layer.masksToBounds = YES;
    }
//    UIImageView * tempImgv = (UIImageView *)[view viewWithTag:1001];
    return view;
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionWrap:
            return YES;
        case iCarouselOptionSpacing:
            return value*0.8;
        case iCarouselOptionFadeMin:
            return -0.5;
        case iCarouselOptionFadeMax:
            return 0.5;
        case iCarouselOptionFadeRange:
            return 2.0;
        default:
            return value;
    }
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    
    CGFloat scale = 1 - (1- fabs((1- fabs(offset))))*0.2;
    CATransform3D translate = CATransform3DTranslate(transform,offset * carousel.itemWidth*0.95, 0.0,0.0);
    return CATransform3DScale(translate, scale, scale, 1);
}


- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    _pageControl.currentPage = carousel.currentItemIndex;
}

- (void)carousel:(iCarousel * __nonnull)carousel didSelectItemAtIndex:(NSInteger)index
{
//    [MobClick event:[@"haowuapp_shouye_dingbutonglan" stringByAppendingFormat:@"%ld", index + 1]];
//    
//    HWBannerModel * model = [_bannerArr pObjectAtIndex:index];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(icarousDidselecteditem:)]) {
//        [self.delegate icarousDidselecteditem:model];
//    }
    [self.itemClickCommand execute:@(index)];
}

- (void)banderautoScroll
{
    if (_currentIndex >= self.dataArr.count)
    {
        _currentIndex = 0;
    }
    
    [_bannerView scrollToItemAtIndex:_currentIndex animated:YES];
    _currentIndex++;
}


- (void)setDataArr:(NSArray *)dataArr
{
    if (_dataArr.count == 1) {
        _dataArr = [NSArray arrayWithObjects:_dataArr[0],_dataArr[0],_dataArr[0], nil];
    }
    else if(_dataArr.count == 2){
        _dataArr = [NSArray arrayWithObjects:_dataArr[0],_dataArr[1],_dataArr[0], nil];
    }
    else
    {
        _dataArr = dataArr;
    }
    [self.bannerView reloadData];
}

@end
