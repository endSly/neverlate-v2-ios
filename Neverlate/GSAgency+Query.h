//
//  GSAgency+Query.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 19/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSAgency.h"

struct GSAgencyQueryPrivate {
    
};

@interface GSAgency (Query)

+ (void)all:(void(^)(NSArray *))callback;

- (void)stops:(void(^)(NSArray *))callback;

@end
