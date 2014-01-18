//
//  GSStopsSearchController.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 12/22/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import Foundation;

@protocol GSStopsSearchControllerDelegate;

@interface GSStopsSearchController : UISearchDisplayController <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray * stops;

@property (nonatomic, weak) IBOutlet id <GSStopsSearchControllerDelegate> stopsSearchDelegate;

@end

@class GSStop;

@protocol GSStopsSearchControllerDelegate <NSObject>

- (void)stopsSearchController:(GSStopsSearchController *)searchController didSelectStop:(GSStop *)stop;

@end


