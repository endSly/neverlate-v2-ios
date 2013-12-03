//
//  GSTrip.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import Foundation;
@import MapKit;

@class GSAgency;
@class GSRoute;
@class GSStop;

@interface GSTrip : NSObject <MKOverlay>

@property (nonatomic, weak) GSAgency    * agency;

@property (nonatomic, strong) NSString  * agency_key;
@property (nonatomic, strong) NSString  * trip_id;
@property (nonatomic, strong) NSString  * trip_headsign;
@property (nonatomic, strong) NSString  * route_id;
@property (nonatomic, strong) NSString  * service_id;
@property (nonatomic, strong) NSNumber  * direction_id;
@property (nonatomic, strong) NSArray   * stop_times;
@property (nonatomic, strong) GSRoute   * route;

@property (nonatomic, readwrite) NSDate * date;

@property (nonatomic, readonly) NSArray * stops;

- (NSDate *)departureDateForStop:(GSStop *)stop;

@end

@interface GSStopTime : NSObject

@property (nonatomic, strong) NSNumber  * stop_sequence;
@property (nonatomic, strong) NSNumber  * arrival_time;
@property (nonatomic, strong) NSNumber  * departure_time;
@property (nonatomic, strong) NSString  * stop_id;

@end