//
//  GSLocationManager.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSLocationManager.h"

NSString * kGSLocationUpdated   = @"kGSLocationUpdated";
NSString * kGSHeadingUpdated    = @"kGSHeadingUpdated";

@implementation GSLocationManager

+ (instancetype)sharedManager
{
    static GSLocationManager *manager = nil;
    if (!manager) {
        manager = [[GSLocationManager alloc] init];
    }
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingHeading];
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    self.heading = newHeading;
    [[NSNotificationCenter defaultCenter] postNotificationName:kGSHeadingUpdated object:self userInfo:@{@"heading": newHeading}];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations.lastObject;
    self.location = location;
    [[NSNotificationCenter defaultCenter] postNotificationName:kGSLocationUpdated object:self userInfo:@{@"location": location}];
}

@end
