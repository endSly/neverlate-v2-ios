//
//  GSTripsTableController.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 20/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import UIKit;
@import MapKit;

@class GSAgency;
@class GSStop;

@interface GSStopInfoTableController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView    * tableView;
@property (nonatomic, weak) IBOutlet MKMapView      * mapView;

@property (nonatomic, weak)   GSAgency  * agency;
@property (nonatomic, strong) GSStop    * stop;

@property (nonatomic, strong) NSArray   * nextDepartures;

@end
