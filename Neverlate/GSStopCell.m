//
//  GSStopCell.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSStopCell.h"

#import "UIFont+IonIcons.h"

#import "GSLocationManager.h"

#import "GSStop.h"

@implementation GSStopCell

- (void)layoutSubviews
{
    if (!_initialized) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo) name:kGSHeadingUpdated  object:GSLocationManager.sharedManager];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo) name:kGSLocationUpdated object:GSLocationManager.sharedManager];
        
        self.headingArrow.font = [UIFont iconicFontOfSize:16];
        self.headingArrow.text = icon_navigate;
        
        self.headingArrow.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.headingArrow.transform = CGAffineTransformMakeRotation(-M_PI / 4);
    }
    [self updateInfo];
}

- (void)setStop:(GSStop *)stop
{
    _stop = stop;
    [self updateInfo];
}

- (void)updateInfo
{
    self.stopDistanceLabel.text = self.stop.formattedDistance;
    self.stopNameLabel.text = self.stop.stop_name;
    self.headingArrow.transform = CGAffineTransformMakeRotation(self.stop.direction * M_PI / 180 + (3 * M_PI / 4));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
