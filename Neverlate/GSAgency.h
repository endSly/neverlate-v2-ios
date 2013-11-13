//
//  GSAgency.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import Foundation;

#import "GSCoordinates.h"

@class GSAgencyBounds;

@interface GSAgency : NSObject

@property (nonatomic, strong) NSString  * agency_key;
@property (nonatomic, strong) NSString  * agency_id;
@property (nonatomic, strong) NSString  * agency_lang;
@property (nonatomic, strong) NSString  * agency_name;
@property (nonatomic, strong) NSString  * agency_phone;
@property (nonatomic, strong) NSString  * agency_timezone;
@property (nonatomic, strong) NSString  * agency_url;
@property (nonatomic, strong) GSCoordinates     * agency_center;
@property (nonatomic, strong) GSAgencyBounds    * agency_bounds;

@end

@interface GSAgencyBounds : NSObject

@property (nonatomic, strong) GSCoordinates * ne;
@property (nonatomic, strong) GSCoordinates * sw;

@end