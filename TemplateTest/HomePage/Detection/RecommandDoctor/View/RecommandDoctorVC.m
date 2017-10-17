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
    self.listView.baseTable.height = self.listView.height = CONTENT_HEIGHT - self.listView.top;
    self.listView.baseTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.listView.isNeedHeadRefresh = false;
    self.listView.clipsToBounds = false;
    self.listView.backgroundColor = [UIColor clearColor];
    self.listView.cellHeight = ^(NSIndexPath *indexPath){
        return (CGFloat)kRate(108);//indexPath.row==0?kRate(308):
    };
    self.listView.didSelected = ^(NSIndexPath *indexPath){
        @strongify(self);
        if (self.viewModel.dataArray.count) {
            DoctorDetailViewModel *model = [DoctorDetailViewModel new];
            model.doctorModel = self.viewModel.dataArray[indexPath.row];
            model.checkId = self.viewModel.checkId;
            [[ViewControllersRouter shareInstance]pushViewModel:model animated:YES];
        }
    };
    self.listView.baseTable.layer.masksToBounds = false;
    if (self.viewModel.needSearchBar) {
        UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-kRate(60), 30)];
        self.searchBar = searchBar;
        UIImage *clearImage = [Utility imageWithColor:[UIColor clearColor] andSize:CGSizeMake(1, 1)];
        [self.searchBar setBackgroundImage:clearImage];
        self.navigationItem.titleView=self.searchBar;
        self.navigationItem.rightBarButtonItem.width = kRate(10);
        self.navigationItem.rightBarButtonItem.customView.width = kRate(10);
        self.searchBar.delegate = self;
        self.searchBar.placeholder = @"附近的口腔医生";

        UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor whiteColor]];
            searchField.layer.cornerRadius = searchBar.height/2.0;
            searchField.layer.borderColor = [UIColor whiteColor].CGColor;
            searchField.layer.borderWidth = 1;
            searchField.layer.masksToBounds = YES;
        }
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
         [self.listView.baseTable reloadData];
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
    RDoctorListCell *cell = [self.listView.baseTable dequeueReusableCellWithIdentifier:kRDoctorVM];
    if (cell == nil) {
        cell = [[RDoctorListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRDoctorVM];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.valueSignal = [RACSignal return:self.viewModel.dataArray[indexPath.row]];
    return cell;
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
