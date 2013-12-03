//
//  GSStop+Query.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 19/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSStop+Query.h"

#import "GSNeverlateService.h"

@implementation GSStop (Query)

- (void)nextDepartures:(void(^)(NSArray *))callback
{
    [[GSNeverlateService sharedService] getNextDepartures:@{@"agency_key": self.agency_key, @"stop_id": self.stop.stop_id} callback:^(NSArray *departures, NSURLResponse *resp, NSError *error) {
        //departures = [departures sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"departure_date" ascending:YES]]];
        callback(departures);
    }];
}

@end
