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
#import "GSDepartureHeaderView.h"

#import "UIFont+IonIcons.h"
#import "ViewFrameAccessor.h"
#import "ScrollViewFrameAccessor.h"

@interface GSStopsTableController (PrivateMethods)

- (void)refreshStops;
- (void)sortStopsByDistance;
- (void)sortStopsAlphabetically;
- (void)loadNextDepartures:(GSStop *)stop;
- (void)refreshHeaderView;

- (void)showDeparturesHeader;
- (void)hideDeparturesHeader;

@end

@implementation GSStopsTableController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0xFF / 255.0f green:0x32 / 255.0f blue:0x04 / 255.0f alpha:0.5];
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
    
    // Build menu options in navBar
    {
        self.title = @"Metro Bilbao";
        
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        [menuButton setTitle:icon_navicon forState:UIControlStateNormal];
        menuButton.titleLabel.font = [UIFont iconicFontOfSize:32];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        
        UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        [mapButton setTitle:icon_ios7_navigate_outline forState:UIControlStateNormal];
        [mapButton setTitle:icon_ios7_navigate forState:UIControlStateSelected];
        mapButton.titleLabel.font = [UIFont iconicFontOfSize:32];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mapButton];
    }
    
    // Build departure header view
    {
        GSDepartureHeaderView *headerView = _headerView = [[NSBundle mainBundle] loadNibNamed:@"GSDepartureHeaderView"
                                                                                        owner:self
                                                                                      options:nil].firstObject;
        
        headerView.frame = CGRectMake(0, -20, self.view.width, 192.0f);
        
        headerView.hidden = YES;
        
        [self.navigationController.navigationBar addSubview:headerView];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kGSLocationUpdated object:GSLocationManager.sharedManager queue:nil usingBlock:^(NSNotification *note) {
        [self sortStopsByDistance];
        
        [self loadNextDepartures:self.stops.firstObject];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kGSHeadingUpdated object:GSLocationManager.sharedManager queue:nil usingBlock:^(NSNotification *note) {
        [self refreshHeaderView];
    }];
    
    [self refreshStops];
}

- (void)refreshStops
{
    [[GSNeverlateService sharedService] getStops:@{@"agency_key": @"metrobilbao"} callback:^(NSArray *stops, NSURLResponse *resp, NSError *error) {
        self.stopsTree = [stops groupBy:^id(GSStop *stop) { return stop.parent_station.length > 0 ? stop.parent_station : NSNull.null; }];
        
        // Get root stops
        self.stops = self.stopsTree[NSNull.null];
        
        if (GSLocationManager.sharedManager.location) {
            [self sortStopsByDistance];
        
            [self loadNextDepartures:self.stops.firstObject];
        } else {
            [self sortStopsAlphabetically];
        }
        
        [self.tableView reloadData];
    }];
}

- (void)sortStopsByDistance
{
    self.stops = [self.stops sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES]]];
}

- (void)sortStopsAlphabetically
{
    self.stops = [self.stops sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"stop_name" ascending:YES]]];
}

- (void)loadNextDepartures:(GSStop *)stop
{
    if (self.nextDeparturesStop == stop)
        return;
    
    self.nextDeparturesStop = stop;
    
    GSStop *logicStop = nil;
    if (!stop.isStop) {
        logicStop = [self.stopsTree[stop.stop_id] find:^BOOL(GSStop *stop) { return stop.isStop; }];
    }
    
    logicStop = logicStop ?: stop;
    
    [[GSNeverlateService sharedService] getNextDepartures:@{@"agency_key": @"metrobilbao", @"stop_id": logicStop.stop_id} callback:^(NSArray *departures, NSURLResponse *resp, NSError *error) {
        
        self.nextDepartures = departures;
        
        [self showDeparturesHeader];
        
        [self refreshHeaderView];
    }];
}

- (void)showDeparturesHeader
{
    if (!_hideFirstStop) {
        [self.tableView beginUpdates];
        _hideFirstStop = YES;
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
    }
    
    GSDepartureHeaderView *headerView = _headerView;
    
    self.navigationItem.title = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    headerView.layer.opacity = 0;
    
    headerView.hidden = NO;
    
    [UIView animateWithDuration:0.35f animations:^{
        self.navigationController.navigationBar.height = 172.0f;
        self.tableView.contentOffsetY -= 128.0f;
        headerView.layer.opacity = 1;
    } completion:^(BOOL finished) {
        self.tableView.contentOffsetY += 128.0f;
    }];
}

- (void)hideDeparturesHeader
{
    GSDepartureHeaderView *headerView = _headerView;
    
    [UIView animateWithDuration:0.35f animations:^{
        self.navigationController.navigationBar.height = 44.0f;
        headerView.layer.opacity = 0;
    } completion:^(BOOL finished) {
        
        headerView.hidden = YES;
    }];
    
}

- (void)refreshHeaderView
{
    GSStop *stop = self.nextDeparturesStop;
    GSDepartureHeaderView *headerView = _headerView;
    GSDeparture *departure1 = self.nextDepartures[0], *departure2 = self.nextDepartures[1];
    
    headerView.stopNameLabel.text = stop.stop_name;
    headerView.distanceLabel.text = stop.formattedDistance;
    headerView.tripHeadsign1.text = departure1.trip_headsign;
    headerView.tripHeadsign2.text = departure2.trip_headsign;
    headerView.departureTime1.text = [NSString stringWithFormat:@"%.0fm", [departure1.departure_date timeIntervalSinceNow] / 60.0f];
    headerView.departureTime2.text = [NSString stringWithFormat:@"%.0fm", [departure2.departure_date timeIntervalSinceNow] / 60.0f];
    headerView.headingAngle = GSLocationManager.sharedManager.heading.trueHeading * M_PI / 180.0;
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
    return _hideFirstStop ? self.stops.count - 1 : self.stops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GSStopCell";
    GSStopCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    GSStop *stop = self.stops[_hideFirstStop ? indexPath.row + 1 : indexPath.row];
    
    cell.stop = stop;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

@end
