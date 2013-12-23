//
//  GSStopCell.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSStopCell.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "UIFont+IonIcons.h"

#import "GSLocationManager.h"

#import "GSStop.h"

@implementation GSStopCell

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (!_initialized) {
        // Configure views
        {
            _initialized = YES;

            self.headingArrow.font = [UIFont iconicFontOfSize:16];
            self.headingArrow.text = icon_navigate;

            self.headingArrow.layer.anchorPoint = CGPointMake(0.5, 0.5);
            self.headingArrow.transform = CGAffineTransformMakeRotation(-M_PI / 4);

            self.distanceContainerView.layer.cornerRadius = 2.0f;
        }

        // Set observers
        {
            RAC(self.stopNameLabel, text)       = RACObserve(self, stop.stop_name);
            RAC(self.entranceNameLabel, text)   = RACObserve(self, stop.subtitle);

            RACSignal *positionUpdated  = [RACSignal combineLatest:@[RACObserve(GSLocationManager.sharedManager, location),
                                                                     RACObserve(GSLocationManager.sharedManager, heading),
                                                                     RACObserve(self, stop)]];

            RACSignal *locationUnavailable = [RACObserve(GSLocationManager.sharedManager, location) map:^(id loc){ return @(loc == nil); }];

            RAC(self.stopDistanceLabel, hidden)     = locationUnavailable;
            RAC(self.headingArrow, hidden)          = locationUnavailable;
            RAC(self.distanceContainerView, hidden) = locationUnavailable;

            [positionUpdated subscribeNext:^(id x) {
                self.headingArrow.transform = CGAffineTransformMakeRotation(self.stop.nearestEntrance.direction * M_PI / 180 + (3 * M_PI / 4));
                self.stopDistanceLabel.text = self.stop.nearestEntrance.formattedDistance;
            }];
        }
    }
}

@end
