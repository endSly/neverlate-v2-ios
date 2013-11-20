//
//  GSStop.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import Foundation;
@import MapKit;

@class GSAgency;

#import "GSCoordinates.h"

NS_ENUM(NSUInteger, GSLocationType) {
    GSLocationTypeStop = 0,
    GSLocationTypeStation = 1,
    GSLocationTypeEntrance = 2,
};

@interface GSStop : NSObject <MKAnnotation> {
    NSString *_stringForSearch;
}

@property (nonatomic, weak) GSAgency    * agency;

@property (nonatomic, strong) NSString  * agency_key;
@property (nonatomic, strong) NSString  * stop_id;
@property (nonatomic, strong) NSString  * stop_code;
@property (nonatomic, strong) NSString  * stop_name;
@property (nonatomic, strong) NSNumber  * location_type;
@property (nonatomic, strong) NSString  * parent_station;
@property (nonatomic, strong) GSCoordinates * loc;

@property (nonatomic, readwrite) NSNumber   * latitude;
@property (nonatomic, readwrite) NSNumber   * longitude;

@property (nonatomic, readonly) CLLocationDistance    distance;
@property (nonatomic, readonly) NSString            * formattedDistance;
@property (nonatomic, readonly) CLLocationDirection   direction;

@property (nonatomic, strong) NSArray   * childStops;

@property (nonatomic, strong) NSArray   * entrances;

/*! @return nearest stop of Entrance type location type or self */
@property (nonatomic, readonly) GSStop  * nearestEntrance;
/*! @return first ocurrence of Stop location type or self */
@property (nonatomic, readonly) GSStop  * stop;
/*! @return first ocurrence of Station location type or self */
@property (nonatomic, readonly) GSStop  * station;

@property (nonatomic, readonly) BOOL isStop;
@property (nonatomic, readonly) BOOL isStation;
@property (nonatomic, readonly) BOOL isEntrance;

@property (nonatomic, readonly) BOOL isRootStation;

@property (nonatomic, readonly, copy) NSString    * subtitle;

@end
