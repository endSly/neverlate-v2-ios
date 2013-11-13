//
//  GSNeverlateService.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import <TenzingCore/TenzingCore.h>
#import <TenzingCore-RESTService/TenzingCore-RESTService.h>

@interface GSNeverlateService : TZRESTService

+ (instancetype) sharedService;

@end


@interface GSNeverlateService (DynamicMethods)

- (void)getAgencies:(NSDictionary *)params  callback:(TZRESTCallback)callback;
- (void)getRoutes:(NSDictionary *)params    callback:(TZRESTCallback)callback;
- (void)getTrips:(NSDictionary *)params     callback:(TZRESTCallback)callback;
- (void)getStops:(NSDictionary *)params     callback:(TZRESTCallback)callback;

- (void)getNextDepartures:(NSDictionary *)params
                 callback:(TZRESTCallback)callback;

@end
