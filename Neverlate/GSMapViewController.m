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

@implementation GSMapViewController {
    REMarkerClusterer *_clusterer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    GSAgencyNavigationController *navigationController = (GSAgencyNavigationController *) self.navigationController;
    self.agency = navigationController.agency;
    
    self.mapView.region = self.agency.region;

    _clusterer = [[REMarkerClusterer alloc] initWithMapView:self.mapView delegate:self];

    _clusterer.gridSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 25 : 20;
    _clusterer.clusterTitle = @"%i stops";

    [self.agency stops:^(NSArray *stops) {
        //[self.mapView addAnnotations:stops];

        for (GSStop *stop in stops) {
            REMarker *marker = [[REMarker alloc] init];
            marker.coordinate = stop.coordinate;
            marker.title = stop.title;
            marker.userInfo = @{ @"stop": stop };
            [_clusterer addMarker:marker];
        }

    }];
    
    self.mapView.showsUserLocation = YES;
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
}

@end
