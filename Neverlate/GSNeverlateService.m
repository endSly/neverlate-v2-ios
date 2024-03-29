//
//  GSNeverlateService.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSNeverlateService.h"

#import "GSNanoStoreServiceCache.h"

#import "GSAgency.h"
#import "GSRoute.h"
#import "GSTrip.h"
#import "GSStop.h"

#define BASE_URL    @"https://neverlate-es-bi.herokuapp.com"
#define AUTH_TOKEN  @"13D062745383DF798B486CB73F7FE539DC165D3B931645473A0D0A823F2F1009"

@implementation GSNeverlateService

+ (instancetype) sharedService
{
    static GSNeverlateService *service = nil;
    if (!service) {
        service = [[GSNeverlateService alloc] init];
        service.baseURL = [NSURL URLWithString:BASE_URL];
        service.cacheStore = [[GSNanoStoreServiceCache alloc] init];
    }
    return service;
}

+ (void)initialize
{
    [self get:@"/api/v1/agencies"           class:GSAgency.class    as:$(getAgencies:callback:) cachePolicy:TZCachePolicyRevalidate expiration:30 * 24 * 60 * 60];
    [self get:@"/api/v1/:agency_key/routes" class:GSRoute.class     as:$(getRoutes:callback:)   cachePolicy:TZCachePolicyRevalidate expiration:30 * 24 * 60 * 60];
    [self get:@"/api/v1/:agency_key/trips"  class:GSTrip.class      as:$(getRoutes:callback:)   cachePolicy:TZCachePolicyRevalidate expiration:30 * 24 * 60 * 60];
    [self get:@"/api/v1/:agency_key/stops"  class:GSStop.class      as:$(getStops:callback:)    cachePolicy:TZCachePolicyRevalidate expiration:30 * 24 * 60 * 60];
    [self get:@"/api/v1/:agency_key/trips/:trip_id"
        class:GSTrip.class
           as:$(getTrip:callback:)
  cachePolicy:TZCachePolicyRevalidate expiration:30 * 24 * 60 * 60];
    
    [self get:@"/api/v1/:agency_key/stops/:stop_id/next-departures"
        class:GSTrip.class
           as:$(getNextDepartures:callback:)
     cachePolicy:TZCachePolicyBypassCache
   expiration:0];
}

#pragma mark - REST Service Delegate

- (void)RESTService:(TZRESTService *)service beforeSendRequest:(NSMutableURLRequest *__autoreleasing *)request
{
    [(*request) addValue:AUTH_TOKEN forHTTPHeaderField:@"Authorization"];
    
    //NSLog(@"[%@] %@ %@", self.class, (*request).HTTPMethod, (*request).URL);
}

- (void)RESTService:(TZRESTService *)service
      afterResponse:(NSURLResponse *__autoreleasing *)resp
               data:(NSData *__autoreleasing *)data
              error:(NSError *__autoreleasing *)error
{
    //NSLog(@"[%@] %li %@", self.class, (long)((NSHTTPURLResponse *) *resp).statusCode, (*resp).MIMEType);
}

@end
