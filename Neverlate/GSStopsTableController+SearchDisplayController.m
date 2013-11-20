//
//  GSStopsTableController+SearchDisplayController.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 20/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSStopsTableController.h"

#import <TenzingCore/TenzingCore.h>

#import "GSStop.h"

@interface GSStop (Search)

@property (nonatomic, readonly) NSString *stringForSearch;

@end

@implementation GSStopsTableController (SearchDisplayController)

#pragma mark - Search display delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSUInteger originalCount = _searchFilteredStops.count;
    
    _searchFilteredStops = [self.stops filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"stringForSearch CONTAINS[cd] %@", searchString]];
    
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
