//
//  GSMapViewController.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 15/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSMapViewController.h"

#import "GSAgencyNavigationController.h"

#import "GSAgency.h"
#import "GSAgency+Query.h"
#import "GSStop.h"

@implementation GSMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    GSAgencyNavigationController *navigationController = (GSAgencyNavigationController *) self.navigationController;
    self.agency = navigationController.agency;
    
    CLLocationCoordinate2D center = self.agency.agency_center.CLLocation.coordinate;
    CLLocationCoordinate2D ne = self.agency.agency_bounds.ne.CLLocation.coordinate;
    CLLocationCoordinate2D sw = self.agency.agency_bounds.sw.CLLocation.coordinate;
    
    self.mapView.region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(ne.latitude - sw.latitude, ne.longitude - sw.longitude));
    
    [self.agency stops:^(NSArray *stops) {
        [self.mapView addAnnotations:stops];
    }];
}

@end
