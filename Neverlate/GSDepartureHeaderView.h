//
//  GSDepartureHeaderView.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import UIKit;

@interface GSDepartureHeaderView : UIView

@property (nonatomic, weak) IBOutlet UILabel    * headingArrow;

@property (nonatomic, weak) IBOutlet UILabel    * stopNameLabel;
@property (nonatomic, weak) IBOutlet UILabel    * distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel    * tripHeadsign1;
@property (nonatomic, weak) IBOutlet UILabel    * tripHeadsign2;
@property (nonatomic, weak) IBOutlet UILabel    * departureTime1;
@property (nonatomic, weak) IBOutlet UILabel    * departureTime2;

@property (nonatomic, weak) IBOutlet UIButton   * menuButton;

@end
