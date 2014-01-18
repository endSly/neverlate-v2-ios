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
    [super layoutSubviews];
    
    if (!_initialized) {
        _initialized = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateInfo)
                                                     name:kGSHeadingUpdated
                                                   object:[GSLocationManager sharedManager]];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateInfo)
                                                     name:kGSLocationUpdated
                                                   object:[GSLocationManager sharedManager]];
        
        self.headingArrow.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.headingArrow.clipsToBounds = NO;
        self.headingArrow.transform = CGAffineTransformMakeRotation(-M_PI / 4);
        
        self.distanceContainerView.layer.cornerRadius = 2.0f;
    }
    [self updateInfo];
}

- (void)setStop:(GSStop *)stop
{
    _stop = stop;
    [self updateInfo];
}

- (UILabel *)detailTextLabel
{
    return self.entranceNameLabel;
}

- (UILabel *)textLabel
{
    return self.stopNameLabel;
}

- (void)updateInfo
{
    BOOL locationAvailable = [GSLocationManager sharedManager].location != nil;

    self.stopDistanceLabel.hidden = !locationAvailable;
    self.headingArrow.hidden = !locationAvailable;
    self.distanceContainerView.hidden = !locationAvailable;

    self.stopDistanceLabel.text = self.stop.nearestEntrance.formattedDistance;
    self.stopNameLabel.text = self.stop.stop_name;
    self.detailTextLabel.text = self.stop.subtitle;
    self.headingArrow.layer.affineTransform = CGAffineTransformMakeRotation(self.stop.nearestEntrance.direction * M_PI / 180);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
