//
//  GSAgency+Query.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 19/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSAgency+Query.h"

#import <TenzingCore/TenzingCore.h>

#import "GSNeverlateService.h"
#import "GSStop.h"
#import "GSTrip.h"

@implementation GSAgency (Query)

+ (void)all:(void(^)(NSArray *))callback
{
    static NSArray *s_agencies = nil;
    if (s_agencies) {
        callback(s_agencies);
        return;
    }
    // else
    
    [[GSNeverlateService sharedService] getAgencies:nil callback:^(NSArray *agencies, NSURLResponse *resp, NSError *error) {
        s_agencies = agencies;
        callback(agencies);
    }];
}

- (void)stops:(void(^)(NSArray *))callback
{
    if (_stops) {
        callback(_stops);
        return;
    }
    
    [[GSNeverlateService sharedService] getStops:@{@"agency_key": self.agency_key} callback:^(NSArray *stops, NSURLResponse *resp, NSError *error) {
        // Reference agency in each stop
        for (GSStop *stop in stops) {
            stop.agency = self;
        }
        
        NSDictionary *stopsMap = [stops dictionaryWithKey:^id(GSStop *stop) { return stop.stop_id; }];
        NSDictionary *stopsTree = [stops groupBy:^id(GSStop *stop) { return stop.isRootStation ? NSNull.null : stop.parent_station; }];
        
        // Build stops tree
        for (id key in stopsTree) {
            if (key == NSNull.null)
                continue;
            GSStop *stop = stopsMap[key];
            stop.childStops = stopsTree[key];
        }
        // Get root stops
        _stops = stopsTree[NSNull.null];
        _stopsMap = stopsMap;
        callback(_stops);
        
    }];
}

- (void)stopWithId:(NSString *)stopId callback:(void(^)(GSStop *))callback
{
    if (_stopsMap) {
        callback(_stopsMap[stopId]);
        return;
    }
    
    [self stops:^(NSArray *stops) {
        callback(_stopsMap[stopId]);
    }];
}

- (void)tripWithId:(NSString *)tripId callback:(void(^)(GSTrip *))callback
{
    [[GSNeverlateService sharedService] getTrip:@{@"agency_key": self.agency_key, @"trip_id": tripId} callback:^(GSTrip *trip, NSURLResponse * resp, NSError *error) {
        trip.agency = self;
        callback(trip);
    }];
}

@end
