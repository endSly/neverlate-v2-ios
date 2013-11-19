//
//  GSStop+Query.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 19/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSStop.h"

@interface GSStop (Query)

- (void)nextDepartures:(void(^)(NSArray *))callback;

@end
