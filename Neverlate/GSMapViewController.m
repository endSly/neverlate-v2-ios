//
//  GSMapViewController.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 15/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSMapViewController.h"

#import "GSNeverlateService.h"

#import "GSStop.h"

@implementation GSMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self loadStops];
}

- (void)loadStops
{
    [[GSNeverlateService sharedService] getStops:@{@"agency_key": @"metrobilbao"} callback:^(NSArray *stops, NSURLResponse *resp, NSError *error) {
        NSDictionary *stopsTree = [stops groupBy:^id(GSStop *stop) { return stop.parent_station.length > 0 ? stop.parent_station : NSNull.null; }];
        
        [self.mapView addAnnotations:stopsTree[NSNull.null]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
