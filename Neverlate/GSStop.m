//
//  GSStop.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSStop.h"

#import "GSLocationManager.h"

@implementation GSStop

- (CLLocationDistance)distance
{
    CLLocation *location = [GSLocationManager sharedManager].location;
    return [location distanceFromLocation:self.loc.CLLocation];
}

@end
