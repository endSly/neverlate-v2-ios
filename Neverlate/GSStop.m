//
//  GSStop.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSStop.h"

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

@end
