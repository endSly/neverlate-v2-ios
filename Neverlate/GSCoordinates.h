//
//  NSArray+GSCoordinates.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import Foundation;
@import CoreLocation;

/*
 * Coordinates are represented in neverlate service by a two positions array
 * [longitude, latitude]
 */

#define GSCoordinates NSArray

@interface NSArray (GSCoordinates)

@property (nonatomic, readonly) NSNumber    * latitude;
@property (nonatomic, readonly) NSNumber    * longitude;

@property (nonatomic, readonly) CLLocation  * CLLocation;

@end
