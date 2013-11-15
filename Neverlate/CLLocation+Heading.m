//
//  CLLocation+Heading.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 15/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "CLLocation+Heading.h"

@implementation CLLocation (Heading)

#define DEG_TO_RAD(deg) (M_PI * (deg) / 180.0)
#define RAD_TO_DEG(rad) ((rad) * 180.0 / M_PI)

- (CLLocationDirection)headingtoLocation:(CLLocation *)toLoc
{
    float fLat = DEG_TO_RAD(self.coordinate.latitude);
    float fLng = DEG_TO_RAD(self.coordinate.longitude);
    float tLat = DEG_TO_RAD(toLoc.coordinate.latitude);
    float tLng = DEG_TO_RAD(toLoc.coordinate.longitude);
    
    CLLocationDirection heading = RAD_TO_DEG(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    
    if (heading < 0)
        return 360 + heading;
    
    return heading;
}

@end
