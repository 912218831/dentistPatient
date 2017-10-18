//
//  RecommandDoctorVC.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "RecommandDoctorVC.h"
#import "MapContentView.h"
#import "RecommandDoctorViewModel.h"
#import "RDoctorListCell.h"
#import "DoctorDetailViewModel.h"
#import "MLSearchBar.h"

@interface RecommandDoctorVC () <UIAlertViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) MapContentView *mapView;
@property (nonatomic, strong) RecommandDoctorViewModel *viewModel;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation RecommandDoctorVC
@dynamic viewModel;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (void)configContentView {
    [super configContentView];
    
    [IQKeyboardManager sharedManager].enable = true;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = true;
    
    // 地图
    self.mapView = [MapContentView buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.mapView];
    self.mapView.frame = (CGRect){CGPointZero, self.contentView.width, kRate(220)};
    @weakify(self);
    // 地图上阴影图片
    UIImageView *shadowImageView = [UIImageView new];
    [self.mapView addSubview:shadowImageView];
    shadowImageView.image = [UIImage imageNamed:@"selectDoctor_icon"];
    [shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.mapView);
        make.height.mas_equalTo(kRate(53));
    }];
    
    [self.contentView bringSubviewToFront:self.listView];
    self.listView.top = kRate(220);
    self.listView.height = self.listView.height = CONTENT_HEIGHT - self.listView.top;
    self.listView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.listView.clipsToBounds = false;
    self.listView.backgroundColor = [UIColor clearColor];
    self.listView.layer.masksToBounds = true;
    if (self.viewModel.needSearchBar) {
        self.navigationItem.rightBarButtonItem = nil;
        UIView *contentV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-kRate(60), 44)];
        MLSearchBar *searchBar = [[MLSearchBar alloc]initWithFrame:CGRectMake(0, 7, contentV.width, 30) boardColor:[UIColor whiteColor] placeholderString:@"附近的口腔医生"];
        self.searchBar = searchBar;
        [contentV.heightAnchor constraintEqualToConstant: 44].active = YES;
        [contentV.widthAnchor constraintEqualToConstant:contentV.width].active=YES;
        [contentV addSubview:searchBar];
        
        UIImage *clearImage = [Utility imageWithColor:[UIColor clearColor] andSize:CGSizeMake(1, 1)];
        [self.searchBar setBackgroundImage:clearImage];
        self.navigationItem.titleView=contentV;
        self.navigationItem.rightBarButtonItem.width = kRate(10);
        self.navigationItem.rightBarButtonItem.customView.width = kRate(10);
        self.searchBar.delegate = self;
        self.searchBar.placeholder = @"附近的口腔医生";
    }
    
}

- (void)bindViewModel {
    [super bindViewModel];
    [self.viewModel bindViewWithSignal];
    
    [Utility showMBProgress:self.contentView message:nil];
    @weakify(self);
    [[self.viewModel.requestSignal.newSwitchToLatest subscribeNext:^(id x) {
        @strongify(self);
    } error:^(NSError *error) {
        @strongify(self);
        [Utility showToastWithMessage:error.domain];
    } completed:nil]finally:^{
         [self.listView reloadData];
        [Utility hideMBProgress:self.contentView];
    }];
    
    // 定位
    [self.mapView.locationFail subscribeNext:^(id x) {
        @strongify(self);
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"隐私" message:@"定位服务尚未打开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [Utility hideMBProgress:self.contentView];
    }];
    [self.mapView.locationSuccess subscribeNext:^(NSValue *x) {
        @strongify(self);
        self.viewModel.coordinate2D = x.MKCoordinateValue;
        [self.viewModel execute];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableViewCell:(NSIndexPath *)indexPath {
    RDoctorListCell *cell = [self.listView dequeueReusableCellWithIdentifier:kRDoctorVM];
    if (cell == nil) {
        cell = [[RDoctorListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRDoctorVM];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.valueSignal = [RACSignal return:self.viewModel.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return (CGFloat)kRate(108);//indexPath.row==0?kRate(308):
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.dataArray.count) {
        DoctorDetailViewModel *model = [DoctorDetailViewModel new];
        model.doctorModel = self.viewModel.dataArray[indexPath.row];
        model.checkId = self.viewModel.checkId;
        [[ViewControllersRouter shareInstance]pushViewModel:model animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    @weakify(self);
    [self.listView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        CGRect result = [self.listView convertRect:obj.frame toView:self.contentView];
        obj.alpha = (CGRectGetMaxY(result) - self.listView.top)/(CGFloat)kRate(108);
    }];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.viewModel.searchText = searchText;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.viewModel execute];
}

- (void)backMethod {
    [super backMethod];
    [[IQKeyboardManager sharedManager]resignFirstResponder];
}

- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
