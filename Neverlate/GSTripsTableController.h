//
//  GSTripsTableController.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 20/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import UIKit;

@class GSAgency;
@class GSStop;

@interface GSTripsTableController : UITableViewController

@property (nonatomic, weak)   GSAgency  * agency;
@property (nonatomic, strong) GSStop    * stop;

@property (nonatomic, strong) NSArray   * nextDepartures;

@end
