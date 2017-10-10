//
//  RecommandDoctorVC.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "RecommandDoctorVC.h"
#import "MapView.h"
#import "RecommandDoctorViewModel.h"
#import "RDoctorListCell.h"
#import "DoctorDetailViewModel.h"

@interface RecommandDoctorVC () <UIAlertViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) MapView *mapView;
@property (nonatomic, strong) RecommandDoctorViewModel *viewModel;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation RecommandDoctorVC
@dynamic viewModel;

- (void)configContentView {
    [super configContentView];
    
    [IQKeyboardManager sharedManager].enable = true;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = true;
    
    self.listView.baseTable.height = self.listView.height = CONTENT_HEIGHT - self.listView.top;
    self.listView.baseTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.listView.isNeedHeadRefresh = false;
    self.listView.backgroundColor = [UIColor clearColor];
    self.listView.cellHeight = ^(NSIndexPath *indexPath){
        return indexPath.row==0?kRate(308):(CGFloat)kRate(108);
    };
    @weakify(self);
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count == 0 ? 1 : self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableViewCell:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MapView *cell = self.mapView;
        if (cell == nil) {
            cell = [[MapView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MapView class])];
            self.mapView = cell;
            RAC(self.viewModel, coordinate2D) = cell.locationSuccess;
            @weakify(self);
            [cell.locationFail subscribeNext:^(id x) {
                @strongify(self);
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"隐私" message:@"定位服务尚未打开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                [Utility hideMBProgress:self.contentView];
            }];
            [cell.locationSuccess subscribeNext:^(id x) {
                @strongify(self);
                [self.viewModel execute];
            }];
        }
        if (self.viewModel.dataArray.count) {
            cell.valueSignal = [RACSignal return:RACTuplePack(self.viewModel.dataArray.firstObject, self.viewModel.annotations)];
        } else {
            cell.valueSignal = nil;
        }
        
        return cell;
    }
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
