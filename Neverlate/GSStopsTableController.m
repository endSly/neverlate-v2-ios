//
//  GSStopsTableController.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSStopsTableController.h"

#import "GSNeverlateService.h"

#import "GSStop.h"

#import "GSStopCell.h"

#import "ViewFrameAccessor.h"
#import "ScrollViewFrameAccessor.h"

@implementation GSStopsTableController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0xFF / 255.0f green:0x32 / 255.0f blue:0x04 / 255.0f alpha:0.5];
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
    
    [[GSNeverlateService sharedService] getStops:@{@"agency_key": @"metrobilbao"} callback:^(NSArray *stops, NSHTTPURLResponse *resp, NSError *error) {
        NSDictionary *stopsHash = [stops groupBy:^id(GSStop *stop) { return stop.parent_station ?: NSNull.null; }];
        NSArray *rootStops = [stops filter:^BOOL(GSStop *stop) { return !(BOOL)(stop.parent_station.boolValue); }];
        
        self.stops = [rootStops sortedArrayUsingComparator:^NSComparisonResult(GSStop *stop1, GSStop *stop2) {
            
        }];
        
        [self.tableView reloadData];
        
        [self loadNextDepartures];
    }];
}

- (void)loadNextDepartures
{
    [[GSNeverlateService sharedService] getNextDepartures:@{@"agency_key": @"metrobilbao", @"stop_id": @"12.0"} callback:^(NSArray *stops, NSHTTPURLResponse *resp, NSError *error) {
        
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
    
    cell.stopNameLabel.text = stop.stop_name;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

@end
