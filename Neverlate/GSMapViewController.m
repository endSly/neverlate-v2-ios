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
    
    self.mapView.region = self.agency.region;
    
    [self.agency stops:^(NSArray *stops) {
        [self.mapView addAnnotations:stops];
    }];
    
    self.mapView.showsUserLocation = YES;
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
}

@end
