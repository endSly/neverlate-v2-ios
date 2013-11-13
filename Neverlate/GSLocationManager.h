//
//  GSLocationManager.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import CoreLocation;

extern NSString * kGSLocationUpdated;
extern NSString * kGSHeadingUpdated;

@interface GSLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation    * location;
@property (nonatomic, strong) CLHeading     * heading;

@property (nonatomic, strong) CLLocationManager * locationManager;

+ (instancetype)sharedManager;

@end
