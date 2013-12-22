//
//  GSStopsSearchController.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 12/22/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSStopsSearchController.h"

@import CoreLocation;
#import <TenzingCore/TenzingCore.h>

#import "GSStop.h"

#import "GSStopCell.h"

@interface GSStop (Search)

@property (nonatomic, readonly) NSString *stringForSearch;

@end

@implementation GSStopsSearchController {
    NSArray *_searchFilteredStops;
    NSArray *_stops;
    NSArray *_placemarks;
}

- (id)initWithStops:(NSArray *)stops
{
    self = [super init];

    if (self) {
        _stops = stops;
    }
    return  self;
}

#pragma mark - Search display delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSUInteger originalCount = _searchFilteredStops.count;

    _searchFilteredStops = [_stops filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"stringForSearch CONTAINS[cd] %@", searchString]];

    if (searchString.length > 3) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];

        [geocoder geocodeAddressString:searchString inRegion:nil completionHandler:^(NSArray *placemarks, NSError *error) {
            _placemarks = placemarks;
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
    return section == 0 ? _searchFilteredStops.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GSStopCell";
    GSStopCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.stop = _searchFilteredStops[indexPath.row];;

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

    NSLog(@"%@", placemark.addressDictionary);

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
