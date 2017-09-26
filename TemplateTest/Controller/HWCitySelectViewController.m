//
//  HWCitySelectViewController.m
//  TemplateTest
//
//  Created by 杨庆龙 on 2017/9/25.
//  Copyright © 2017年 caijingpeng.haowu. All rights reserved.
//

#import "HWCitySelectViewController.h"
#import "HWCityModel_CD+CoreDataClass.h"
#import "HWCitySelectLocationCell.h"
@interface HWCitySelectViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>

@property(strong,nonatomic)NSFetchedResultsController * fetchController;
@property(strong,nonatomic)UITableView * table;

@end

@implementation HWCitySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)configContentView
{
    [super configContentView];
    [self.view addSubview:self.table];
    [self fetchData];
}

- (UITableView *)table
{
    if (_table == nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CONTENT_HEIGHT) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerNib:[UINib nibWithNibName:@"HWCitySelectLocationCell" bundle:nil] forCellReuseIdentifier:@"HWCitySelectLocationCell"];
        [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    }
    return _table;
}

- (NSFetchedResultsController *)fetchController
{
    if (_fetchController == nil) {
        _fetchController = [HWCityModel_CD MR_fetchAllSortedBy:@"cityFirstChar" ascending:YES withPredicate:nil groupBy:nil delegate:self];

        _fetchController.delegate = self;
    }
    return _fetchController;
}

- (void)fetchData{
    NSError *error = nil;

    [self.fetchController performFetch:&error];
    if (error) {
        
    }
    else
    {
        [self.table reloadData];
    }
}

#pragma UITableViewDelegate  && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchController sections].count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchController sections][section];
        return [sectionInfo numberOfObjects];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [tableView dequeueReusableCellWithIdentifier:@"HWCitySelectLocationCell"];
    }
    else
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
        return cell;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma fetchDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.table beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.table;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
//            [self configureCell:(RecipeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
//            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.table endUpdates];
}

@end
