//
//  GSDeparture.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSDeparture.h"

#import "ISO8601DateFormatter.h"

#import "GSRoute.h"

@implementation GSDeparture

- (void)setDeparture_date:(NSDate *)departure_date
{
    if ([departure_date isKindOfClass:NSDate.class]) {
        _departure_date = departure_date;
        return;
    }
    
    // Convert to date if it is a atring
    if ([departure_date isKindOfClass:NSString.class]) {
        static ISO8601DateFormatter *dateFormatter = nil;
        if (!dateFormatter)
        dateFormatter = [[ISO8601DateFormatter alloc] init];
        
        _departure_date = [dateFormatter dateFromString:(NSString *)departure_date];
        return;
    }
}

- (NSString *)title
{
    return self.trip_headsign.length != 0
    ? self.trip_headsign
    : [NSString stringWithFormat:@"%@ %@", self.route.route_short_name, self.route.route_long_name];
}

@end
