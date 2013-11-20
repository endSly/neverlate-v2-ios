//
//  GSStopsTableController.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSStopsTableController.h"

#import <ECSlidingViewController/UIViewController+ECSlidingViewController.h>
#import <TenzingCore/TenzingCore.h>

#import "GSLocationManager.h"

#import "GSAgency.h"
#import "GSAgency+Query.h"
#import "GSStop.h"
#import "GSStop+Query.h"
#import "GSDeparture.h"

#import "GSTripsTableController.h"

#import "GSIndeterminatedProgressView.h"
#import "GSNavigationBar.h"
#import "GSStopCell.h"
#import "GSDepartureHeaderView.h"

#import "UIFont+IonIcons.h"
#import "ViewFrameAccessor.h"
#import "ScrollViewFrameAccessor.h"

@interface GSStopsTableController (PrivateMethods)

- (void)loadStops;
- (void)sortStopsByDistance;
- (void)sortStopsAlphabetically;
- (void)loadNextDepartures;
- (void)refreshHeaderView;

- (void)showAgenciesMenuAction:(id)sender;
- (void)showMapAction:(id)sender;

- (void)locationHasUpdated;

- (void)showDeparturesHeader:(BOOL)animated;
- (void)hideDeparturesHeader:(BOOL)animated;

@end

@implementation GSStopsTableController {
    GSDepartureHeaderView *_headerView;
    
    NSTimer *_timer;
    
    BOOL _isHeaderVisible;
    
    BOOL _nextDeparturesStopSelected;
    
    NSArray *_stopsForTable;
    
    NSArray *_searchFilteredStops;
}

#pragma  mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.contentOffsetY = 44.0f; // Hide search bar

    [self buildNavigationItem];
    
    // Build departure header view
    {
        GSDepartureHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"GSDepartureHeaderView"
                                                                          owner:self
                                                                        options:nil].firstObject;
        
        headerView.frame = CGRectMake(0, -20, self.view.width, 192.0f);
        headerView.hidden = YES;
        [headerView.showMapButton addTarget:self action:@selector(showMapAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView.menuButton addTarget:self action:@selector(showAgenciesMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTripsAction:)]];
        
        [self.navigationController.navigationBar addSubview:headerView];
        
        _headerView = headerView;
    }
    
    [self.tableView  registerNib:[UINib nibWithNibName:@"GSStopCell" bundle:nil] forCellReuseIdentifier:@"GSStopCell"];
    
    [self.searchDisplayController.searchResultsTableView  registerNib:[UINib nibWithNibName:@"GSStopCell" bundle:nil]
                                               forCellReuseIdentifier:@"GSStopCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationHasUpdated) name:kGSLocationUpdated object:GSLocationManager.sharedManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeaderView)  name:kGSHeadingUpdated  object:GSLocationManager.sharedManager];
}

- (void)viewWillAppear:(BOOL)animated
{
    _nextDeparturesStopSelected = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateNextDepartures) userInfo:nil repeats:YES];
    [_timer fire];
    
    if (self.agency) {
        GSNavigationBar *navigationBar = (GSNavigationBar *) self.navigationController.navigationBar;
        navigationBar.barTintColor = [self.agency.agency_color colorWithAlphaComponent:0.5f];
        navigationBar.indeterminateProgressView.progressTintColor = [self.agency.agency_color colorWithAlphaComponent:0.65f];
        [self loadStops];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_timer invalidate];
}

- (void)viewWillLayoutSubviews
{
    self.navigationController.navigationBar.height = _isHeaderVisible ? 172.0f : 44.0f;
}

#pragma mark - Helpers

- (void)buildNavigationItem
{
    self.navigationItem.title = self.agency.agency_name;
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    menuButton.titleLabel.font = [UIFont iconicFontOfSize:32];
    [menuButton setTitle:icon_navicon forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showAgenciesMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    mapButton.titleLabel.font = [UIFont iconicFontOfSize:32];
    [mapButton setTitle:icon_ios7_navigate_outline forState:UIControlStateNormal];
    [mapButton setTitle:icon_ios7_navigate forState:UIControlStateSelected];
    [mapButton addTarget:self action:@selector(showMapAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mapButton];
}

- (void)showMapAction:(id)sender
{
    [self performSegueWithIdentifier:@"GSShowMapSegue" sender:self];
}

- (void)showTripsAction:(id)sender
{
    [self performSegueWithIdentifier:@"GSShowTripsSegue" sender:self];
}

- (void)showAgenciesMenuAction:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void)showNextDeparturesStop:(GSStop *)nextDeparturesStop
{
    if (self.nextDeparturesStop == nextDeparturesStop)
        return;
    
    self.nextDeparturesStop = nextDeparturesStop;
    
    _stopsForTable = [self.stops filter:^BOOL(GSStop *stop) { return stop != nextDeparturesStop; }];
    
    [self hideDeparturesHeader:YES];
    [self loadNextDepartures];
}

- (void)locationHasUpdated
{
    [self sortStopsByDistance];
    
    if (!_nextDeparturesStopSelected) {
        [self showNextDeparturesStop:self.stops.firstObject];
        
        [self.tableView reloadData];
        
        [self refreshHeaderView];
    }
}

- (void)loadStops
{
    self.stops = nil;
    [self.tableView reloadData];
    
    GSNavigationBar *navigationBar = (GSNavigationBar *) self.navigationController.navigationBar;
    
    [navigationBar.indeterminateProgressView startAnimating];
    [self.agency stops:^(NSArray *stops) {
        [navigationBar.indeterminateProgressView stopAnimating];
        
        self.stops = stops;
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
    if (self.nextDepartures.count < 2) {
        [self hideDeparturesHeader:YES];
    } else {
        [self showDeparturesHeader:YES];
    }
    
    if (self.nextDepartures && self.nextDepartures.count < 6) {
        [self loadNextDepartures];
    }
    [self refreshHeaderView];
}

- (void)loadNextDepartures
{
    self.nextDepartures = nil;

    GSNavigationBar *navigationBar = (GSNavigationBar *) self.navigationController.navigationBar;
    
    [navigationBar.indeterminateProgressView startAnimating];
    [self.nextDeparturesStop nextDepartures:^(NSArray *departures) {
        [navigationBar.indeterminateProgressView stopAnimating];
        
        self.nextDepartures = departures;
        
        [self showDeparturesHeader:YES];
        
        [self refreshHeaderView];
    }];
}

- (void)refreshHeaderView
{
    GSStop *stop = self.nextDeparturesStop;
    GSDepartureHeaderView *headerView = _headerView;
    GSDeparture *departure1 = self.nextDepartures[0], *departure2 = self.nextDepartures[1];
    
    headerView.stopNameLabel.text = stop.stop_name;
    headerView.entranceNameLabel.text = stop.subtitle;
    headerView.distanceLabel.text = stop.formattedDistance;
    headerView.tripHeadsign1.text = departure1.title;
    headerView.tripHeadsign2.text = departure2.title;
    NSTimeInterval departure1Interval = [departure1.departure_date timeIntervalSinceNow] / 60.0f;
    if (departure1Interval > 120.0f) {
        headerView.departureTime1.text = @"+120m";
    } else {
        headerView.departureTime1.text = [NSString stringWithFormat:@"%.0fm", departure1Interval];
    }
    
    NSTimeInterval departure2Interval = [departure2.departure_date timeIntervalSinceNow] / 60.0f;
    if (departure2Interval > 120.0f) {
        headerView.departureTime2.text = @"+120m";
    } else {
        headerView.departureTime2.text = [NSString stringWithFormat:@"%.0fm", departure2Interval];
    }
    
    headerView.headingAngle = stop.direction * M_PI / 180.0;
}

#pragma mark - Departures Header Control

- (void)showDeparturesHeader:(BOOL)animated
{
    if (_isHeaderVisible)
        return;
    
    _isHeaderVisible = YES;
    
    [self.tableView reloadData];
    
    GSDepartureHeaderView *headerView = _headerView;
    
    self.navigationItem.title = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    headerView.hidden = NO;
    
    if (animated) {
        headerView.layer.opacity = 0;
        
        [UIView animateWithDuration:0.25f animations:^{
            self.navigationController.navigationBar.height = 172.0f;
            self.tableView.contentOffsetY -= 128.0f;
            headerView.layer.opacity = 1;
        } completion:^(BOOL finished) {
            self.tableView.contentOffsetY += 128.0f;
        }];
    } else {
        self.navigationController.navigationBar.height = 172.0f;
    }
}

- (void)hideDeparturesHeader:(BOOL)animated
{
    if (!_isHeaderVisible)
        return;
    
    _isHeaderVisible = NO;
    
    [self.tableView reloadData];

    GSDepartureHeaderView *headerView = _headerView;
    
    if (animated) {
        [UIView animateWithDuration:0.25f animations:^{
            self.navigationController.navigationBar.height = 44.0f;
            headerView.layer.opacity = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                headerView.hidden = YES;
                [self buildNavigationItem];
            }
        }];
    } else {
        self.navigationController.navigationBar.height = 44.0f;
        headerView.hidden = YES;
        [self buildNavigationItem];
    }
}

- (GSStop *)stopForRow:(NSUInteger)row
{
    return _isHeaderVisible
    ? _stopsForTable[row]
    : self.stops[row];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return _isHeaderVisible ? _stopsForTable.count : self.stops.count;
    } else {
        return _searchFilteredStops.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GSStopCell";
    GSStopCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    GSStop *stop;
    if (tableView == self.tableView) {
        stop = [self stopForRow:indexPath.row];
    } else {
        stop = _searchFilteredStops[indexPath.row];
    }
    cell.stop = stop;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchDisplayController setActive:NO animated:YES];
    
    _nextDeparturesStopSelected = YES;
    [self showNextDeparturesStop:[self stopForRow:indexPath.row]];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView reloadData];
}

#pragma mark - Search display delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSUInteger originalCount = _searchFilteredStops.count;
    
    _searchFilteredStops = [self.stops filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"stop_name CONTAINS[cd] %@", searchString]];
    
    return originalCount != _searchFilteredStops.count;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    _searchFilteredStops = self.stops;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    _searchFilteredStops = nil;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self hideDeparturesHeader:YES];
    
    if ([segue.identifier isEqualToString:@"GSShowTripsSegue"]) {
        GSTripsTableController *tripsTableController = (GSTripsTableController *) segue.destinationViewController;
        tripsTableController.stop = self.nextDeparturesStop;
    }
}

@end
