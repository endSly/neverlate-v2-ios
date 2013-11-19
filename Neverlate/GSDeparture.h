//
//  GSDeparture.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSTrip.h"

@class GSRoute;

@interface GSDeparture : GSTrip

@property (nonatomic, strong, readwrite) NSDate * departure_date;

@property (nonatomic, strong) GSRoute   * route;

@property (nonatomic, readonly) NSString    * title;


@end
