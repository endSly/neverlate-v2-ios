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
    
    NSTimer *_timer;
    
    BOOL _isHeaderVisible;
}

@property (nonatomic, weak) GSStop      * nextDeparturesStop;
@property (nonatomic, strong) NSArray   * nextDepartures;

@property (nonatomic, strong) NSArray   * stops;

@end
