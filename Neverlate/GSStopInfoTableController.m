//
//  GSTripsTableController.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 20/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSStopInfoTableController.h"

#import "GSAgency.h"
#import "GSAgency+Query.h"
#import "GSStop.h"
#import "GSStop+Query.h"
#import "GSDeparture.h"

#import "GSAgencyNavigationController.h"

#import "FrameAccessor.h"
#import "ScrollViewFrameAccessor.h"

@interface GSStopInfoTableController ()

@end

@implementation GSStopInfoTableController

- (void)viewDidLoad
{
    [super viewDidLoad];

    GSAgencyNavigationController *navigationController = (GSAgencyNavigationController *) self.navigationController;
    self.agency = navigationController.agency;
    
    self.title = self.stop.stop_name;
    
    [self.mapView addAnnotation:self.stop];
    [self.mapView addAnnotations:self.stop.childStops];
    
    self.mapView.userInteractionEnabled = NO;
    self.mapView.showsUserLocation = YES;
    
    CLLocationCoordinate2D center = self.stop.coordinate;
    center.latitude -= 0.0015;
    self.mapView.region = MKCoordinateRegionMakeWithDistance(center, 600, 600);
    
    [self.stop nextDepartures:^(NSArray *departures) {
        self.nextDepartures = departures;
        [self.tableView reloadData];
    }];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nextDepartures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.locale = [NSLocale currentLocale];
    }
    
    static NSString *CellIdentifier = @"GSDepartureCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    GSDeparture *departure = self.nextDepartures[indexPath.row];
    cell.textLabel.text = departure.title;
    
    cell.detailTextLabel.text = [dateFormatter stringFromDate:departure.departure_date];
    
    return cell;
}

#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 1)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GSDeparture *departure = self.nextDepartures[indexPath.row];
    
    [self.agency tripWithId:departure.trip_id callback:^(GSTrip *trip) {
        
    }];
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
