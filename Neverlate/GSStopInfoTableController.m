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
#import "GSTrip.h"

#import "GSAgencyNavigationController.h"

#import "UIBarButtonItem+IonIcons.h"
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
    
    self.mapView.showsUserLocation = YES;

    [self.mapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandMapAction:)]];

    CLLocationCoordinate2D center = self.stop.coordinate;
    center.latitude -= 0.0015;
    self.mapView.region = MKCoordinateRegionMakeWithDistance(center, 600, 600);
    
    [self.stop nextDepartures:^(NSArray *departures) {
        self.nextDepartures = departures;
        [self.tableView reloadData];
    }];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
}

- (void)expandMapAction:(id)sender
{
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.y = self.view.height;
    } completion:^(BOOL finished){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:icon_ios7_close_outline target:self action:@selector(contractMapAction:)];
    }];
}

- (void)contractMapAction:(id)sender
{
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.y = 300;
    } completion:^(BOOL finished){
        self.navigationItem.leftBarButtonItem = nil;
    }];
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
    
    GSTrip *departure = self.nextDepartures[indexPath.row];
    cell.textLabel.text = departure.title;
    
    cell.detailTextLabel.text = [dateFormatter stringFromDate:[departure departureDateForStop:self.stop]];
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GSTrip *departure = self.nextDepartures[indexPath.row];
    
    [self.agency tripWithId:departure.trip_id callback:^(GSTrip *trip) {
        [self.mapView addOverlay:trip];
    }];
}

#pragma mark - Map view delegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    GSTrip *trip = (GSTrip *)overlay;
    NSArray *stops = trip.stops;
    CLLocationCoordinate2D coordinates[stops.count];
    
    int i = 0;
    for (GSStop *stop in stops) {
        coordinates[i++] = stop.coordinate;
    }
    
    MKPolyline *tripPath = [MKPolyline polylineWithCoordinates:coordinates count:stops.count];
    MKPolylineRenderer *tripRenderer = [[MKPolylineRenderer alloc] initWithPolyline:tripPath];
    tripRenderer.fillColor = [UIColor redColor];
    tripRenderer.lineWidth = 4.0f;
    return tripRenderer;
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
