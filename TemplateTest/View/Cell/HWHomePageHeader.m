//
//  HWHomePageHeader.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/12.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWHomePageHeader.h"

@interface HWHomePageHeader()<iCarouselDelegate,iCarouselDataSource>

@property(strong,nonatomic)iCarousel * bannerView;
@property(strong,nonatomic)NSArray * dataArr;
@end

@implementation HWHomePageHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArr = @[COLOR_F0512B,COLOR_80C8E7,COLOR_EC7E33,COLOR_28BEFF,COLOR_144271];
        [self addSubview:self.bannerView];
        self.backgroundColor = COLOR_F0F0F0;
        
    }
    return self;
}

- (iCarousel *)bannerView
{
    if (_bannerView == nil) {
        _bannerView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, floor(kRate(170)))];
        _bannerView.delegate = self;
        _bannerView.dataSource = self;
        _bannerView.type = iCarouselTypeCustom;
        _bannerView.scrollToItemBoundary = YES;
        _bannerView.pagingEnabled = YES;
        _bannerView.backgroundColor = COLOR_F0F0F0;
    }
    return _bannerView;
}

#pragma icarousel delegate && datasource

- (NSInteger)numberOfItemsInCarousel:(iCarousel * __nonnull)carousel
{
    return 3;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 60, self.bannerView.height)];
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectInset(view.bounds, 0, 0)];
        imgV.tag = 1001;
        [view addSubview:imgV];
    }
    UIImageView * tempImgv = (UIImageView *)[view viewWithTag:1001];
    tempImgv.backgroundColor = self.dataArr[index];
    return view;
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionSpacing:
            return value*1.1 ;
            break;
        case iCarouselOptionWrap:
            return YES;
        default:
            return value;
            break;
    }
    return value;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    
    CGFloat scale = 1 - (1- fabs((1- fabs(offset))))*0.1;
    CATransform3D translate = CATransform3DTranslate(transform,offset * carousel.itemWidth*0.95, 0.0,0.0);
    return CATransform3DScale(translate, scale, scale, 1);
}


//- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
//{
//    _pageCtrl.currentPage = carousel.currentItemIndex;
//}

- (void)carousel:(iCarousel * __nonnull)carousel didSelectItemAtIndex:(NSInteger)index
{
//    [MobClick event:[@"haowuapp_shouye_dingbutonglan" stringByAppendingFormat:@"%ld", index + 1]];
//    
//    HWBannerModel * model = [_bannerArr pObjectAtIndex:index];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(icarousDidselecteditem:)]) {
//        [self.delegate icarousDidselecteditem:model];
//    }
}

//- (void)banderautoScroll
//{
//    if (_currentIndex >= _bannerArr.count)
//    {
//        _currentIndex = 0;
//    }
//    
//    [_carousel scrollToItemAtIndex:_currentIndex animated:YES];
//    _currentIndex++;
//}


@end
