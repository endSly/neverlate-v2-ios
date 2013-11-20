//
//  GSAgency+Query.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 19/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSAgency.h"

@class GSStop;
@class GSTrip;

@interface GSAgency (Query)

+ (void)all:(void(^)(NSArray *))callback;

- (void)stops:(void(^)(NSArray *))callback;
- (void)stopWithId:(NSString *)stopId callback:(void(^)(GSStop *))callback;
- (void)tripWithId:(NSString *)tripId callback:(void(^)(GSTrip *))callback;

@end
