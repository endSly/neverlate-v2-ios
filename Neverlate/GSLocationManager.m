//
//  GSLocationManager.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSLocationManager.h"

@implementation GSLocationManager

- (id)init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager startUpdatingHeading];
        [self.locationManager startUpdatingLocation];
        self.locationManager.delegate = self;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations.lastObject;
}

@end
