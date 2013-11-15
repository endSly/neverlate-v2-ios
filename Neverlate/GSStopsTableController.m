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

#import "GSIndeterminatedProgressView.h"
#import "GSNavigationBar.h"
#import "GSStopCell.h"
#import "GSDepartureHeaderView.h"

#import "UIFont+IonIcons.h"
#import "ViewFrameAccessor.h"
#import "ScrollViewFrameAccessor.h"

@interface GSStopsTableController (PrivateMethods)

- (void)refreshStops;
- (void)sortStopsByDistance;
- (void)sortStopsAlphabetically;
- (void)loadNextDepartures;
- (void)refreshHeaderView;

- (void)headingHasUpdated;
- (void)locationHasUpdated;

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
        [mapButton addTarget:self action:@selector(showMap) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mapButton];
    }
    
    // Build departure header view
    {
        GSDepartureHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"GSDepartureHeaderView"
                                                                          owner:self
                                                                        options:nil].firstObject;
        
        headerView.frame = CGRectMake(0, -20, self.view.width, 192.0f);
        headerView.hidden = YES;
        [self.navigationController.navigationBar addSubview:headerView];
        _headerView = headerView;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationHasUpdated) name:kGSLocationUpdated object:GSLocationManager.sharedManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headingHasUpdated)  name:kGSHeadingUpdated  object:GSLocationManager.sharedManager];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateNextDepartures) userInfo:nil repeats:YES];
    [_timer fire];
    
    [self refreshStops];
}

- (void)viewWillLayoutSubviews
{
    if (_isHeaderVisible) {
        self.navigationController.navigationBar.height = 172.0f;
    } else {
        self.navigationController.navigationBar.height = 44.0f;
    }
}

- (void)showMap
{
    [self performSegueWithIdentifier:@"GSShowMapSegue" sender:self];
}

- (void)headingHasUpdated
{
    [self refreshHeaderView];
}

- (void)locationHasUpdated
{
    [self sortStopsByDistance];
    
    if (self.nextDeparturesStop != self.stops.firstObject) {
        self.nextDeparturesStop = self.stops.firstObject;
        
        [self loadNextDepartures];
    }
    
    [self.tableView reloadData];
    
    [self refreshHeaderView];
}

- (void)refreshStops
{
    [((GSNavigationBar *) self.navigationController.navigationBar) showIndeterminateProgressIndicator];
    [[GSNeverlateService sharedService] getStops:@{@"agency_key": @"metrobilbao"} callback:^(NSArray *stops, NSURLResponse *resp, NSError *error) {
        [((GSNavigationBar *) self.navigationController.navigationBar) hideIndeterminateProgressIndicator];
        
        NSDictionary *stopsTree = [stops groupBy:^id(GSStop *stop) { return stop.parent_station.length > 0 ? stop.parent_station : NSNull.null; }];
        
        // Get root stops
        self.stops = stopsTree[NSNull.null];
        
        // Build stops tree
        for (GSStop *stop in self.stops) {
            stop.childStops = stopsTree[stop.stop_id];
        }
        
        if (GSLocationManager.sharedManager.location) {
            [self locationHasUpdated];
        } else {
            [self sortStopsAlphabetically];
        }
        
        [self.tableView reloadData];
    }];
}

- (void)sortStopsByDistance
{
    self.stops = [self.stops sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"nearestEntrance.distance" ascending:YES]]];
}

- (void)sortStopsAlphabetically
{
    self.stops = [self.stops sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"stop_name" ascending:YES]]];
}

- (void)updateNextDepartures
{
    self.nextDepartures = [self.nextDepartures filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"departure_date > %@", [NSDate date]]];
    if (self.nextDepartures && self.nextDepartures.count < 6) {
        [self loadNextDepartures];
    }
    [self refreshHeaderView];
}

- (void)loadNextDepartures
{
    GSStop *logicStop = self.nextDeparturesStop.stop;
    
    [((GSNavigationBar *) self.navigationController.navigationBar) showIndeterminateProgressIndicator];
    [[GSNeverlateService sharedService] getNextDepartures:@{@"agency_key": @"metrobilbao", @"stop_id": logicStop.stop_id} callback:^(NSArray *departures, NSURLResponse *resp, NSError *error) {
        [((GSNavigationBar *) self.navigationController.navigationBar) hideIndeterminateProgressIndicator];
        
        self.nextDepartures = [departures sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"departure_date" ascending:YES]]];
        
        [self showDeparturesHeader];
        
        [self refreshHeaderView];
    }];
}

- (void)refreshHeaderView
{
    GSStop *stop = self.nextDeparturesStop;
    GSDepartureHeaderView *headerView = _headerView;
    GSDeparture *departure1 = self.nextDepartures[0], *departure2 = self.nextDepartures[1];
    
    headerView.stopNameLabel.text = stop.stop_name;
    headerView.entranceNameLabel.text = stop.nearestEntrance.stop_name;
    headerView.distanceLabel.text = stop.formattedDistance;
    headerView.tripHeadsign1.text = departure1.trip_headsign;
    headerView.tripHeadsign2.text = departure2.trip_headsign;
    headerView.departureTime1.text = [NSString stringWithFormat:@"%.0fm", [departure1.departure_date timeIntervalSinceNow] / 60.0f];
    headerView.departureTime2.text = [NSString stringWithFormat:@"%.0fm", [departure2.departure_date timeIntervalSinceNow] / 60.0f];
    headerView.headingAngle = stop.direction * M_PI / 180.0;
}

- (void)showDeparturesHeader
{
    if (!_isHeaderVisible) {
        [self.tableView beginUpdates];
        _isHeaderVisible = YES;
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
    return _isHeaderVisible ? self.stops.count - 1 : self.stops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GSStopCell";
    GSStopCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    GSStop *stop = self.stops[_isHeaderVisible ? indexPath.row + 1 : indexPath.row];

    cell.stop = stop;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

@end
