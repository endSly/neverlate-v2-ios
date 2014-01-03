//
//  GSStopsSearchController.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 12/22/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSStopsSearchDisplayController.h"

@import CoreLocation;
#import <TenzingCore/TenzingCore.h>

#import "GSStop.h"

#import "GSStopCell.h"

@interface GSStop (Search)

@property (nonatomic, readonly) NSString *stringForSearch;

@end

@implementation GSStopsSearchDisplayController {
    NSArray *_searchFilteredStops;
    NSArray *_placemarks;
    NSArray *_placemarkStops;
}

- (id)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController
{
    self = [super initWithSearchBar:searchBar contentsController:viewController];

    if (self) {
        [self.searchResultsTableView registerNib:[UINib nibWithNibName:@"GSStopCell" bundle:nil]
                          forCellReuseIdentifier:@"GSStopCell"];

        self.delegate = self;
        self.searchResultsDataSource = self;
        self.searchResultsDelegate = self;
    }

    return self;
}

#pragma mark - Search display delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if ([searchString isEqualToString:@":set hideAds=true"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kGSHideAds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return NO;
    }
    if ([searchString isEqualToString:@":set hideAds=false"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kGSHideAds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return NO;
    }

    NSUInteger originalCount = _searchFilteredStops.count;

    _searchFilteredStops = [_stops filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"stringForSearch CONTAINS[cd] %@", searchString]];

    if (searchString.length > 3) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];

        [geocoder geocodeAddressString:searchString inRegion:nil completionHandler:^(NSArray *placemarks, NSError *error) {
            _placemarks = placemarks;

            NSMutableArray *placemarkStops = [NSMutableArray arrayWithCapacity:_placemarks.count];

            for (CLPlacemark *placemark in placemarks) {
                NSArray *stopsByPlacemark = [_stops sortedArrayWithOptions:NSSortConcurrent usingComparator:^(GSStop *stop1, GSStop *stop2) {
                    return [stop1.loc.CLLocation distanceFromLocation:placemark.location] < [stop2.loc.CLLocation distanceFromLocation:placemark.location]
                    ? NSOrderedAscending
                    : NSOrderedDescending;
                }];
                [placemarkStops addObject:stopsByPlacemark];
            }
            _placemarkStops = placemarkStops;

            [controller.searchResultsTableView reloadData];
        }];
    }

    return originalCount != _searchFilteredStops.count;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    _searchFilteredStops = _stops;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    _searchFilteredStops = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + _placemarks.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? _searchFilteredStops.count : MIN(3, _stops.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GSStopCell";
    GSStopCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (indexPath.section > 0) {
        cell.stop = _placemarkStops[indexPath.section - 1][indexPath.row];
    } else {
        cell.stop = _searchFilteredStops[indexPath.row];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return nil;

    CLPlacemark *placemark = _placemarks[section - 1];

    return [(NSArray *) (placemark.addressDictionary[@"FormattedAddressLines"]) join:@", "];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0 : 24.0f;
}


@end



@implementation GSStop (Search)

- (NSString *)stringForSearch
{
    if (_stringForSearch)
        return _stringForSearch;

    _stringForSearch = [NSString stringWithFormat:@"%@ %@ %@",
                        self.stop_code ?: @"",
                        self.stop_name ?: @"",
                        [[self.childStops map:^id(GSStop *stop) { return stop.stringForSearch; }] join:@" "] ?: @""];

    return _stringForSearch;
}

@end
