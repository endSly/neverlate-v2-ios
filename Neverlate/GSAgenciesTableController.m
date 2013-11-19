//
//  GSAgenciesTebleController.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 16/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSAgenciesTableController.h"

#import "FrameAccessor.h"

#import "GSNeverlateService.h"
#import "GSAgency.h"
#import "GSAgency+Query.h"

#import "GSStopsTableController.h"

#import "GSNavigationBar.h"
#import "GSIndeterminatedProgressView.h"

@interface GSAgenciesTableController ()

@end

@implementation GSAgenciesTableController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:85 / 255.0f green:87 / 255.0f blue:89 / 255.0f alpha:1];
    
    GSNavigationBar *navigationBar = (GSNavigationBar *) self.navigationController.navigationBar;
    navigationBar.indeterminateProgressView.progressTintColor = navigationBar.barTintColor;
    
    [navigationBar.indeterminateProgressView startAnimating];
    [GSAgency all:^(NSArray *agencies) {
        [navigationBar.indeterminateProgressView stopAnimating];
        self.agencies = agencies;
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.agencies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GSAgencyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    GSAgency *agency = self.agencies[indexPath.row];
    
    cell.textLabel.textColor = UIColor.whiteColor;
    cell.textLabel.text = agency.agency_name;

    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = (UITableViewCell*) sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    GSAgency *agency = self.agencies[indexPath.row];
    
    GSStopsTableController * stopsTableController = ((UINavigationController *) segue.destinationViewController).viewControllers.firstObject;
    
    stopsTableController.agency = agency;
}

@end
