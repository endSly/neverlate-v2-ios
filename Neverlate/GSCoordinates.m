//
//  NSArray+GSCoordinates.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSCoordinates.h"

@implementation NSArray (GSCoordinates)

- (NSNumber *)latitude
{
    return self[1];
}

- (NSNumber *)longitude
{
    return self[0];
}

- (CLLocation *)CLLocation
{
    return [[CLLocation alloc] initWithLatitude:self.latitude.floatValue
                                      longitude:self.longitude.floatValue];
}

@end
