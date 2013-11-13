//
//  GSStopCell.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import UIKit;

@class GSStop;

@interface GSStopCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel * headingArrow;
@property (nonatomic, weak) IBOutlet UILabel * stopNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * stopDistanceLabel;

@property (nonatomic, strong) GSStop    * stop;

@end
