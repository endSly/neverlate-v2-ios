//
//  GSNeverlateService.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSNeverlateService.h"

#import "GSAgency.h"
#import "GSRoute.h"
#import "GSTrip.h"
#import "GSStop.h"

#define BASE_URL    @"https://neverlate-service.herokuapp.com"
#define AUTH_TOKEN  @"13D062745383DF798B486CB73F7FE539DC165D3B931645473A0D0A823F2F1009"

@implementation GSNeverlateService

+ (instancetype) sharedService
{
    static GSNeverlateService *service = nil;
    if (!service) {
        service = [[GSNeverlateService alloc] init];
        service.baseURL = [NSURL URLWithString:BASE_URL];
    }
    return service;
}

+ (void)initialize
{
    [self get:@"/api/v1/agencies"           class:GSAgency.class    as:$(getAgencies:callback:)];
    [self get:@"/api/v1/:agency_key/routes" class:GSRoute.class     as:$(getRoutes:callback:)];
    [self get:@"/api/v1/:agency_key/trips"  class:GSTrip.class      as:$(getRoutes:callback:)];
    [self get:@"/api/v1/:agency_key/stops"  class:GSStop.class      as:$(getStops:callback:)];
    
    [self get:@"/api/v1/:agency_key/stops/:stop_id/next-departures"
        class:GSStop.class
           as:$(getNextDepartures:callback:)];
}

@end
