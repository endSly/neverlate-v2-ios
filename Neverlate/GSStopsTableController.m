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
#import "GSTrip.h"

#import "GSAgencyNavigationController.h"
#import "GSStopInfoTableController.h"

#import "GSIndeterminatedProgressView.h"
#import "GSNavigationBar.h"
#import "GSStopCell.h"
#import "GSDepartureHeaderView.h"
#import "GADBannerView.h"

#import "UIBarButtonItem+IonIcons.h"
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
}

#pragma  mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.contentOffsetY = 44.0f; // Hide search bar

    // Build departure header view
    {
        GSDepartureHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"GSDepartureHeaderView"
                                                                          owner:self
                                                                        options:nil].firstObject;
        
        headerView.frame = CGRectMake(0, -20, self.view.width, 192.0f);
        headerView.hidden = YES;
        [headerView.showMapButton addTarget:self action:@selector(showMapAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView.menuButton addTarget:self action:@selector(showAgenciesMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showStopInfoAction:)]];
        
        [self.navigationController.navigationBar addSubview:headerView];
        
        _headerView = headerView;
    }
    
    [self.tableView  registerNib:[UINib nibWithNibName:@"GSStopCell" bundle:nil] forCellReuseIdentifier:@"GSStopCell"];
    
    [self.searchDisplayController.searchResultsTableView  registerNib:[UINib nibWithNibName:@"GSStopCell" bundle:nil]
                                               forCellReuseIdentifier:@"GSStopCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationHasUpdated) name:kGSLocationUpdated object:GSLocationManager.sharedManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeaderView)  name:kGSHeadingUpdated  object:GSLocationManager.sharedManager];
    
    _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    _bannerView.adUnitID = @"a1529f2900969fa";
    _bannerView.rootViewController = self;
    [self refreshBanner];
    
    [NSTimer scheduledTimerWithTimeInterval:15000 target:self selector:@selector(refreshBanner) userInfo:nil repeats:YES];
}

- (void)refreshBanner
{
    GADRequest *request = [GADRequest request];
    
    CLLocation *location = [GSLocationManager sharedManager].location;
    if (location) {
        [request setLocationWithLatitude:location.coordinate.latitude
                               longitude:location.coordinate.longitude
                                accuracy:location.horizontalAccuracy];
    }
    [_bannerView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated
{
    GSAgencyNavigationController *navigationController = (GSAgencyNavigationController *) self.navigationController;
    self.agency = navigationController.agency;
    
    { // Build toolbar
        self.navigationController.toolbarHidden = NO;
        self.toolbarItems =
        @[
          [[UIBarButtonItem alloc] initWithIcon:icon_ios7_calendar_outline color:self.agency.agency_color target:self action:@selector(showCalendarAction:)],
          [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
          [[UIBarButtonItem alloc] initWithIcon:icon_ios7_navigate_outline color:self.agency.agency_color target:self action:@selector(showMapAction:)],
          ];
        NSLog(@"--- %@", self.navigationController.toolbar);
    }


    _nextDeparturesStopSelected = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateNextDepartures) userInfo:nil repeats:YES];
    [_timer fire];
    
    if (self.agency) {
        if (!_isHeaderVisible)
            [self buildNavigationItem];
        
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

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:icon_navicon target:self action:@selector(showAgenciesMenuAction:)];
}

- (void)showMapAction:(id)sender
{
    [self hideDeparturesHeader:YES];
    [self performSegueWithIdentifier:@"GSShowMapSegue" sender:self];
}

- (void)showStopInfoAction:(id)sender
{
    [self performSegueWithIdentifier:@"GSShowStopInfoSegue" sender:self];
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
    self.nextDepartures = [self.nextDepartures filter:^BOOL(GSTrip *trip) {
        return [[trip departureDateForStop:self.nextDeparturesStop] timeIntervalSinceNow] > 0;
    }];

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
    if (self.nextDepartures.count < 2)
        return;

    GSStop *stop = self.nextDeparturesStop;
    GSDepartureHeaderView *headerView = _headerView;
    GSTrip *departure1 = self.nextDepartures[0], *departure2 = self.nextDepartures[1];
    
    headerView.stopNameLabel.text = stop.stop_name;
    headerView.entranceNameLabel.text = stop.subtitle;
    headerView.distanceLabel.text = stop.formattedDistance;
    headerView.tripHeadsign1.text = departure1.title;
    headerView.tripHeadsign2.text = departure2.title;
    NSTimeInterval departure1Interval = [[departure1 departureDateForStop:stop] timeIntervalSinceNow] / 60.0f;
    if (departure1Interval > 120.0f) {
        headerView.departureTime1.text = @"+120m";
    } else {
        headerView.departureTime1.text = [NSString stringWithFormat:@"%.0fm", departure1Interval];
    }
    
    NSTimeInterval departure2Interval = [[departure1 departureDateForStop:stop] timeIntervalSinceNow] / 60.0f;
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
            headerView.layer.opacity = 1;
        } completion:nil];
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _bannerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kGADAdSizeBanner.size.height;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self hideDeparturesHeader:YES];
    
    if ([segue.identifier isEqualToString:@"GSShowStopInfoSegue"]) {
        GSStopInfoTableController *tripsTableController = (GSStopInfoTableController *) segue.destinationViewController;
        tripsTableController.stop = self.nextDeparturesStop;
    }
}

@end
