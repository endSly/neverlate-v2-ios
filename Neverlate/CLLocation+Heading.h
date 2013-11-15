//
//  CLLocation+Heading.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 15/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import CoreLocation;

@interface CLLocation (Heading)

- (CLLocationDirection)headingtoLocation:(CLLocation *)toLoc;

@end
