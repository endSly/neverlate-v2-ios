//
//  GSStop.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSStop.h"

@implementation GSStop

- (NSNumber *)latitude
{
    return self.loc[1];
}

- (NSNumber *)longitude
{
    return self.loc[0];
}

- (void)setLatitude:(NSNumber *)latitude
{
    NSMutableArray *loc = self.loc ? [self.loc mutableCopy] : [NSMutableArray arrayWithObjects:@0, @0, nil];
    loc[1] = latitude;
    self.loc = loc;
}

- (void)setLongitude:(NSNumber *)longitude
{
    NSMutableArray *loc = self.loc ? [self.loc mutableCopy] : [NSMutableArray arrayWithObjects:@0, @0, nil];
    loc[0] = longitude;
    self.loc = loc;
}

@end
