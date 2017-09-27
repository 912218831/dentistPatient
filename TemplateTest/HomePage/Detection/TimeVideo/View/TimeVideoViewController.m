//
//  TimeVideoViewController.m
//  TemplateTest
//
//  Created by HW on 17/9/16.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "TimeVideoViewController.h"
#import "TimeVideoViewModel.h"
@interface TimeVideoViewController ()
@property (nonatomic, strong) TimeVideoViewModel *viewModel;
@end

@implementation TimeVideoViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backMethod {
    [super backMethod];
    self.viewModel.takePhoto([UIImage imageNamed:@"beautiful.jpg"]);
}

@end
