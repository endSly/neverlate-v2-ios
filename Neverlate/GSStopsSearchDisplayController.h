//
//  GSStopsSearchController.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 12/22/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import Foundation;

@interface GSStopsSearchDisplayController : UISearchDisplayController <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray * stops;

@end
