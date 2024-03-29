//
//  GSMapViewController.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 15/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import UIKit;
@import MapKit;

#import <REMarkerClusterer/REMarkerClusterer.h>

@class GSAgency;

@interface GSMapViewController : UIViewController <REMarkerClusterDelegate>

@property (nonatomic, weak) IBOutlet MKMapView  * mapView;

@property (nonatomic, strong) GSAgency * agency;

@end
