//
//  GSStopsTableController.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSStopsTableController.h"

#import "GSNeverlateService.h"

#import "GSLocationManager.h"

#import "GSStop.h"
#import "GSDeparture.h"

#import "GSStopCell.h"

#import "UIFont+IonIcons.h"
#import "ViewFrameAccessor.h"
#import "ScrollViewFrameAccessor.h"

@interface GSStopsTableController (PrivateMethods)

- (void)refreshStops;
- (void)sortStopsByDistance;
- (void)loadNextDepartures:(GSStop *)stop;

@end

@implementation GSStopsTableController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0xFF / 255.0f green:0x32 / 255.0f blue:0x04 / 255.0f alpha:0.5];
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setTitle:icon_navicon forState:UIControlStateNormal];
    menuButton.titleLabel.font = [UIFont iconicFontOfSize:18];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kGSLocationUpdated object:GSLocationManager.sharedManager queue:nil usingBlock:^(NSNotification *note) {
        [self sortStopsByDistance];
        
        [self.tableView reloadData];
    }];
    
    [self refreshStops];
}

- (void)refreshStops
{
    [[GSNeverlateService sharedService] getStops:@{@"agency_key": @"metrobilbao"} callback:^(NSArray *stops, NSHTTPURLResponse *resp, NSError *error) {
        self.stopsTree = [stops groupBy:^id(GSStop *stop) { return stop.parent_station.length > 0 ? stop.parent_station : NSNull.null; }];
        
        // Get root stops
        self.stops = self.stopsTree[NSNull.null];
        
        [self sortStopsByDistance];
        
        [self loadNextDepartures:self.stops.firstObject];
        
        [self.tableView reloadData];
    }];
}

- (void)sortStopsByDistance
{
    self.stops = [self.stops sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES]]];
}

- (void)loadNextDepartures:(GSStop *)stop
{
    [[GSNeverlateService sharedService] getNextDepartures:@{@"agency_key": @"metrobilbao", @"stop_id": stop.stop_id} callback:^(NSArray *stops, NSHTTPURLResponse *resp, NSError *error) {
        
        [UIView animateWithDuration:0.5f animations:^{
            self.navigationController.navigationBar.height = 172.0f;
            self.tableView.contentInsetTop = 192.0f;
            self.tableView.contentOffsetY -= 128.0f;
        }];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GSStopCell";
    GSStopCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    GSStop *stop = self.stops[indexPath.row];
    
    cell.stop = stop;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

@end
