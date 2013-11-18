//
//  GSRoute.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import Foundation;

@interface GSRoute : NSObject

@property (nonatomic, strong) NSString  * agency_key;
@property (nonatomic, strong) NSString  * route_id;
@property (nonatomic, strong) UIColor   * route_color;
@property (nonatomic, strong) NSString  * route_short_name;
@property (nonatomic, strong) NSString  * route_long_name;
@property (nonatomic, strong) NSNumber  * route_type;
@property (nonatomic, strong) NSArray   * stop_ids;

@end
