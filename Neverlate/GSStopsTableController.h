//
//  GSStopsTableController.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import UIKit;

@class GSAgency;
@class GSStop;
@class GSDepartureHeaderView;

@class GADBannerView;

@interface GSStopsTableController : UITableViewController <UISearchDisplayDelegate>

@property (nonatomic, strong) GSAgency  * agency;

@property (nonatomic, weak)   GSStop    * nextDeparturesStop;
@property (nonatomic, strong) NSArray   * nextDepartures;

@property (nonatomic, strong) NSArray   * stops;

@end
