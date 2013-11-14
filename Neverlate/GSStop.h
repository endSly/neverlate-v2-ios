//
//  GSStop.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import Foundation;

#import "GSCoordinates.h"

NS_ENUM(NSUInteger, GSLocationType) {
    GSLocationTypeStop = 0,
    GSLocationTypeStation = 1,
    GSLocationTypeEntrance = 2,
};

@interface GSStop : NSObject

@property (nonatomic, strong) NSString  * agency_key;
@property (nonatomic, strong) NSString  * stop_id;
@property (nonatomic, strong) NSString  * stop_code;
@property (nonatomic, strong) NSString  * stop_name;
@property (nonatomic, strong) NSNumber  * location_type;
@property (nonatomic, strong) NSString  * parent_station;
@property (nonatomic, strong) GSCoordinates * loc;

@property (nonatomic, readwrite) NSNumber   * latitude;
@property (nonatomic, readwrite) NSNumber   * longitude;

@property (nonatomic, readonly) CLLocationDistance distance;
@property (nonatomic, readonly) NSString    * formattedDistance;

@property (nonatomic, readonly, getter = isStop)        BOOL stop;
@property (nonatomic, readonly, getter = isStation)     BOOL station;
@property (nonatomic, readonly, getter = isEntrance)    BOOL entrance;

@end
