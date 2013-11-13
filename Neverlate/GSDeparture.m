//
//  GSDeparture.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSDeparture.h"

#import "ISO8601DateFormatter.h"

@implementation GSDeparture

- (void)setDeparture_date:(NSDate *)departure_date
{
    if ([departure_date isKindOfClass:NSDate.class]) {
        _departure_date = departure_date;
        return;
    }
    
    // Convert to date if it is a atring
    if ([departure_date isKindOfClass:NSString.class]) {
        static ISO8601DateFormatter *dateFormatter = nil;
        if (!dateFormatter)
        dateFormatter = [[ISO8601DateFormatter alloc] init];
        
        _departure_date = [dateFormatter dateFromString:(NSString *)departure_date];
        return;
    }
}

@end
