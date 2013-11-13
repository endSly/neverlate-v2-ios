//
//  GSStop.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import Foundation;

@interface GSStop : NSObject

@property (nonatomic, strong) NSString  * agency_key;
@property (nonatomic, strong) NSString  * stop_id;
@property (nonatomic, strong) NSString  * stop_code;
@property (nonatomic, strong) NSString  * stop_name;
@property (nonatomic, strong) NSNumber  * location_type;
@property (nonatomic, strong) NSString  * parent_station;
@property (nonatomic, strong) NSArray   * loc;

@property (nonatomic, readwrite) NSNumber   * latitude;
@property (nonatomic, readwrite) NSNumber   * longitude;

@end
