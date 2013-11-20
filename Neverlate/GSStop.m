//
//  GSStop.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSStop.h"

#import <TenzingCore/TenzingCore.h>

#import "GSLocationManager.h"

#import "CLLocation+Heading.h"

@implementation GSStop

- (CLLocationDistance)distance
{
    CLLocation *location = [GSLocationManager sharedManager].location;
    if (!location)
        return 0;
    
    return [location distanceFromLocation:self.loc.CLLocation];
}

- (NSString *)formattedDistance
{
    CLLocationDistance distance = self.distance;
    if (distance >= 1000.0f) {
        return [NSString stringWithFormat:@"%.1fkm", distance / 1000.0f];
    }
    return [NSString stringWithFormat:@"%.0fm", distance];
    
}

- (CLLocationDirection)direction
{
    return [self.loc.CLLocation headingtoLocation:[GSLocationManager sharedManager].location]
    - GSLocationManager.sharedManager.heading.trueHeading;
}

- (GSStop *)nearestEntrance
{
    CLLocation *location = [GSLocationManager sharedManager].location;
    if (!location)
        return nil;
    
    return [self.entrances sortedArrayUsingSelector:@selector(distance)].firstObject ?: self;
}

- (NSArray *)entrances
{
    return [self.childStops filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"location_type = %u", GSLocationTypeEntrance]];
}

- (GSStop *)stop
{
    if (self.isStop) return self;
    
    GSStop *stop = [self.childStops find:^BOOL(GSStop *s) { return s.isStop; }];
    return stop ?: self;
}

- (GSStop *)station
{
    if (self.isStation) return self;
    
    GSStop *station = [self.childStops find:^BOOL(GSStop *s) { return s.isStation; }];
    return station ?: self;
}

- (BOOL)isStop
{
    return self.location_type.intValue == GSLocationTypeStop;
}

- (BOOL)isStation
{
    return self.location_type.intValue == GSLocationTypeStation;
}

- (BOOL)isEntrance
{
    return self.location_type.intValue == GSLocationTypeEntrance;
}

- (BOOL)isRootStation
{
    return self.parent_station.length == 0;
}


#pragma mark - MapKit Annotation

- (CLLocationCoordinate2D)coordinate
{
    return self.loc.CLLocation.coordinate;
}

- (NSString *)title
{
    return self.stop_name;
}

- (NSString *)subtitle
{
    return self.nearestEntrance && self.nearestEntrance != self
    ? self.nearestEntrance.stop_name
    : self.stop_code;
}

@end
