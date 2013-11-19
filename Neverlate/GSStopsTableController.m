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

#import "GSAgency.h"
#import "GSStop.h"
#import "GSDeparture.h"

#import <ECSlidingViewController/UIViewController+ECSlidingViewController.h>

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

@implementation GSStopsTableController

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
        
        [self.navigationController.navigationBar addSubview:headerView];
        
        _headerView = headerView;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationHasUpdated) name:kGSLocationUpdated object:GSLocationManager.sharedManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeaderView)  name:kGSHeadingUpdated  object:GSLocationManager.sharedManager];
}

- (void)viewWillAppear:(BOOL)animated
{
    _selectedStopIndex = -1;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateNextDepartures) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_timer invalidate];
}

- (void)viewWillLayoutSubviews
{
    self.navigationController.navigationBar.height = _isHeaderVisible ? 172.0f : 44.0f;
}

- (void)setAgency:(GSAgency *)agency
{
    if (_agency == agency) return;
    
    _agency = agency;
    
    self.navigationController.navigationBar.barTintColor = [agency.agency_color colorWithAlphaComponent:0.5f];
    
    [self loadStops];
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
    [self hideDeparturesHeader:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"GSShowMapSegue" sender:self];
    });
}

- (void)showAgenciesMenuAction:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void)setNextDeparturesStop:(GSStop *)nextDeparturesStop
{
    if (self.nextDeparturesStop == nextDeparturesStop)
        return;
    
    _nextDeparturesStop = nextDeparturesStop;
    
    [self hideDeparturesHeader:YES];
    [self loadNextDepartures];
}

- (void)locationHasUpdated
{
    [self sortStopsByDistance];
    
    if (_selectedStopIndex < 0) {
        self.nextDeparturesStop = self.stops.firstObject;
        
        [self.tableView reloadData];
        
        [self refreshHeaderView];
    }
}

- (void)loadStops
{
    self.stops = nil;
    [self.tableView reloadData];
    
    [((GSNavigationBar *) self.navigationController.navigationBar).indeterminateProgressView startAnimating];
    [[GSNeverlateService sharedService] getStops:@{@"agency_key": self.agency.agency_key} callback:^(NSArray *stops, NSURLResponse *resp, NSError *error) {
        [((GSNavigationBar *) self.navigationController.navigationBar).indeterminateProgressView stopAnimating];
        
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
    
    GSStop *logicStop = self.nextDeparturesStop.stop;
    
    GSNavigationBar *navigationBar = (GSNavigationBar *) self.navigationController.navigationBar;
    GSIndeterminatedProgressView *progressView = navigationBar.indeterminateProgressView;
    
    [progressView startAnimating];
    [[GSNeverlateService sharedService] getNextDepartures:@{@"agency_key": self.agency.agency_key, @"stop_id": logicStop.stop_id} callback:^(NSArray *departures, NSURLResponse *resp, NSError *error) {
        [progressView stopAnimating];
        
        self.nextDepartures = [departures sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"departure_date" ascending:YES]]];
        
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
    headerView.entranceNameLabel.text = stop.nearestEntrance.stop_name;
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
    
    [self.tableView beginUpdates];
    _isHeaderVisible = YES;
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    
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
    
    [self.tableView beginUpdates];
    _isHeaderVisible = NO;
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    
    
    
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

- (GSStop *)stopForIndex:(NSUInteger)index
{
    if (_isHeaderVisible) {
        if (_selectedStopIndex < 0 || index >= _selectedStopIndex) {
            return self.stops[index + 1];
        }
    }
    return self.stops[index];
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
    
    GSStop *stop = [self stopForIndex:indexPath.row];

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
    _selectedStopIndex = indexPath.row;
    self.nextDeparturesStop = [self stopForIndex:_selectedStopIndex];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
}

@end
