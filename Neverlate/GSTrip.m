//
//  GSTrip.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSTrip.h"

#import <TenzingCore/TenzingCore.h>

#import "GSAgency+Query.h"
#import "GSRoute.h"
#import "GSStop.h"

#import "ISO8601DateFormatter.h"

@implementation GSTrip

- (Class)stop_timesClass {
    return [GSStopTime class];
}

- (void)setDate:(NSDate *)date
{
    if ([date isKindOfClass:NSDate.class]) {
        _date = date;
        return;
    }
    
    // Convert to date if it is a atring
    if ([date isKindOfClass:NSString.class]) {
        static ISO8601DateFormatter *dateFormatter = nil;
        if (!dateFormatter)
            dateFormatter = [[ISO8601DateFormatter alloc] init];
        
        _date = [dateFormatter dateFromString:(NSString *)date];
        return;
    }
}

- (NSArray *)stops
{
    @synchronized(self) {
        // Wait for stops load
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [self.agency stops:^(NSArray *stops) {
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        __block NSMutableArray *stops = [NSMutableArray arrayWithCapacity:self.stop_times.count];
        
        self.stop_times = [self.stop_times sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"stop_sequence" ascending:YES]]];
        
        for (GSStopTime *stopTime in self.stop_times) {
            [self.agency stopWithId:stopTime.stop_id callback:^(GSStop *stop) {
                [stops addObject:stop];
            }];
        }
        
        return stops;
    }
}

- (NSDate *)departureDateForStop:(GSStop *)stop
{
    GSStopTime *time = [self.stop_times find:^BOOL(GSStopTime *time) { return [time.stop_id isEqualToString:stop.stop.stop_id]; }];
    return [self.date dateByAddingTimeInterval:time.departure_time.floatValue];
}

- (MKMapRect)boundingMapRect
{
    CGFloat n = self.agency.agency_bounds.ne.latitude.floatValue,
    e = self.agency.agency_bounds.ne.longitude.floatValue,
    s = self.agency.agency_bounds.sw.latitude.floatValue,
    w = self.agency.agency_bounds.sw.longitude.floatValue;
    
    return MKMapRectWorld;
    
    return MKMapRectMake(n, e, n - s, e - w);
}

- (CLLocationCoordinate2D)coordinate
{
    MKMapRect rect = self.boundingMapRect;
    return CLLocationCoordinate2DMake(rect.origin.x + rect.size.width / 2.0f, rect.origin.y + rect.size.height / 2.0f);
}

- (MKCoordinateRegion)region
{
    CLLocationDegrees n = INFINITY, s = -INFINITY, e = INFINITY, w = -INFINITY;
    for (GSStop *stop in self.stops) {
        n = MIN(n, stop.loc.latitude.doubleValue);
        s = MAX(s, stop.loc.latitude.doubleValue);
        e = MIN(e, stop.loc.longitude.doubleValue);
        w = MAX(w, stop.loc.longitude.doubleValue);
    }
    
    return (MKCoordinateRegion) {
        .center = {
            .latitude = (n + s) / 2.0,
            .longitude = (e + w) / 2.0
        },
        .span = {
            .latitudeDelta = (n + s) / 2.0 - n,
            .longitudeDelta = (e + w) / 2.0 - e
        }
    };
}

- (NSString *)title
{
    return self.trip_headsign.length != 0
    ? self.trip_headsign
    : [NSString stringWithFormat:@"%@ %@", self.route.route_short_name, self.route.route_long_name];
}

@end

@implementation GSStopTime

@end
