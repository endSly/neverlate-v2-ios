//
//  GSStopsSearchController.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 12/22/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSStopsSearchController : NSObject <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

- (id)initWithStops:(NSArray *)stops;

@end
