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

@implementation GSStopsTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.barTintColor = [UIColor.redColor colorWithAlphaComponent:0.6];
    
    [[GSNeverlateService sharedService] getStops:@{@"agency_key": @"metrobilbao"} callback:^(NSArray *stops, NSHTTPURLResponse *resp, NSError *error) {
        self.stops = stops;
        [self.tableView reloadData];
        
        [self loadNextDepartures];
    }];
}

- (void)loadNextDepartures
{
    [[GSNeverlateService sharedService] getNextDepartures:@{@"agency_key": @"metrobilbao", @"stop_id": @"12.0"} callback:^(NSArray *stops, NSHTTPURLResponse *resp, NSError *error) {
        [UIView animateWithDuration:0.7 animations:^{
            CGRect frame = self.navigationController.navigationBar.frame;
            frame.size.height = 200.0f;
            self.navigationController.navigationBar.frame = frame;
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
    
    cell.textLabel.text = stop.stop_name;
    cell.detailTextLabel.text = stop.stop_code;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
