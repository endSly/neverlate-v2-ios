//
//  GSStopsTableController.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import UIKit;

@class GSStop;
@class GSDepartureHeaderView;

@interface GSStopsTableController : UITableViewController {
    GSDepartureHeaderView *_headerView;
}

@property (nonatomic, weak) GSStop  * showDeparturesStop;

@property (nonatomic, strong) NSArray       * stops;
@property (nonatomic, strong) NSDictionary  * stopsTree;

@end
