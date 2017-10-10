//
//  CaseDetailViewController.m
//  TemplateTest
//
//  Created by HW on 17/9/13.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "CaseDetailViewController.h"
#import "CaseDetailViewModel.h"
#import "CaseDetailInfoCell.h"
#import "HZPhotoGroup.h"
#import "HZPhotoItem.h"

@interface CaseDetailViewController () <UITableViewDelegate,
                                    UITableViewDataSource,
                                    UIImagePickerControllerDelegate>
@property (nonatomic, strong) CaseDetailViewModel *viewModel;
@property (nonatomic, strong) UITableView *listView;
@end

@implementation CaseDetailViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [(HWTabBarViewController *)SHARED_APP_DELEGATE.viewController setTabBarHidden:true animated:YES];
}

- (void)configContentView {
    [super configContentView];
    
    self.listView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.listView.height -= 49+10;
    self.listView.delegate = self;
    self.listView.dataSource = self;
    self.listView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.listView];
}

- (void)bindViewModel {
    [super bindViewModel];
    [self.viewModel bindViewWithSignal];
    @weakify(self);
    [self.viewModel.requestSignal.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.listView reloadData];
    }error:^(NSError *error) {
        [Utility showToastWithMessage:error.domain];
    }];
    
    [self.viewModel.uploadImageSignal.newSwitchToLatest subscribeNext:^(NSNumber *x) {
        @strongify(self);
        [Utility showMBProgress:self.contentView message:nil];
        
    } error:^(NSError *error) {
        @strongify(self);
        [Utility hideMBProgress:self.contentView];
        [Utility showToastWithMessage:error.domain];
        [self.listView reloadData];
    } completed:^{
        [Utility hideMBProgress:self.contentView];
        [Utility showToastWithMessage:@"病历照片上传成功"];
        [self.listView reloadData];
    }];
    
    [self.viewModel execute];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row==0?kRate(256):self.viewModel.imageCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        CaseDetailInfoCell *cell = [[CaseDetailInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.backgroundColor = self.listView.backgroundColor;
        cell.valueSignal = [RACSignal return:self.viewModel.model];
        @weakify(self);
        [cell.uploadImageSignal subscribeNext:^(UIButton *sender) {
            @strongify(self);
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:true completion:nil];
        }];
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = self.listView.backgroundColor;
        
        HZPhotoGroup *photoGroup = [[HZPhotoGroup alloc] init];
        
        NSMutableArray *temp = [NSMutableArray array];
        [self.viewModel.model.images enumerateObjectsUsingBlock:^(CaseDetailImageModel *imageModel, NSUInteger idx, BOOL *stop) {
            HZPhotoItem *item = [[HZPhotoItem alloc] init];
            item.thumbnail_pic = imageModel.ImgUrl;
            [temp addObject:item];
        }];
        
        photoGroup.photoItemArray = [temp copy];
        [cell addSubview:photoGroup];
        return cell;
    }
    return nil;
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:true completion:nil];
    self.viewModel.waitUploadImage = originImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
