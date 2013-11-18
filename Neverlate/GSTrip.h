//
//  GSTrip.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import Foundation;

@interface GSTrip : NSObject

@property (nonatomic, strong) NSString  * agency_key;
@property (nonatomic, strong) NSString  * trip_id;
@property (nonatomic, strong) NSString  * trip_headsign;
@property (nonatomic, strong) NSString  * route_id;
@property (nonatomic, strong) NSString  * service_id;
@property (nonatomic, strong) NSNumber  * direction_id;
@property (nonatomic, strong) NSArray   * stop_ids;

@end
