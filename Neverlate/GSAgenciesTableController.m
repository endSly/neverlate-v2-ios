//
//  GSAgenciesTebleController.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 16/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSAgenciesTableController.h"

#import <FrameAccessor/FrameAccessor.h>
#import <ECSlidingViewController/UIViewController+ECSlidingViewController.h>

#import "GSNeverlateService.h"
#import "GSAgency.h"
#import "GSAgency+Query.h"

#import "GSAgencyNavigationController.h"

#import "GSNavigationBar.h"
#import "GSIndeterminatedProgressView.h"

NSString * const kGSSelectedAgencyKey = @"kGSSelectedAgencyKey";

@implementation GSAgenciesTableController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:85 / 255.0f green:87 / 255.0f blue:89 / 255.0f alpha:1];
    
    GSNavigationBar *navigationBar = (GSNavigationBar *) self.navigationController.navigationBar;

    [navigationBar.indeterminateProgressView startAnimating];
    [GSAgency all:^(NSArray *agencies) {
        [navigationBar.indeterminateProgressView stopAnimating];

        self.agencies = agencies;

        NSString *selectedAgency = [[NSUserDefaults standardUserDefaults] objectForKey:kGSSelectedAgencyKey];
        if (selectedAgency) {
            GSAgency *agency = [agencies filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"agency_key = %@", selectedAgency]].lastObject;
            if (agency) {
                [self performSegueWithIdentifier:@"ShowAgencySegue" sender:agency];
                [self.slidingViewController resetTopViewAnimated:NO];
            }
        }

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
    GSAgency *agency;
    if ([sender isKindOfClass:[GSAgency class]]) {
        agency = sender;
    } else {
        UITableViewCell *cell = (UITableViewCell*) sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        agency = self.agencies[indexPath.row];
    }
    
    GSAgencyNavigationController *agencyNavigation = (GSAgencyNavigationController *) segue.destinationViewController;
    agencyNavigation.agency = agency;

    // Save last selected agency
    [[NSUserDefaults standardUserDefaults] setObject:agency.agency_key forKey:kGSSelectedAgencyKey];
}

@end
