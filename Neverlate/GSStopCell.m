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
        _initialized = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo) name:kGSHeadingUpdated  object:[GSLocationManager sharedManager]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo) name:kGSLocationUpdated object:[GSLocationManager sharedManager]];
        
        self.headingArrow.font = [UIFont iconicFontOfSize:16];
        self.headingArrow.text = icon_navigate;
        
        self.headingArrow.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.headingArrow.transform = CGAffineTransformMakeRotation(-M_PI / 4);
        
        self.distanceContainerView.layer.cornerRadius = 2.0f;

        RAC(self.stopNameLabel, text)       = RACObserve(self, stop.stop_name);
        RAC(self.stopDistanceLabel, text)   = RACObserve(self, stop.nearestEntrance.formattedDistance);
        RAC(self.entranceNameLabel, text)   = RACObserve(self, stop.subtitle);

        RAC(self.headingArrow, transform)   = [RACSignal combineLatest:@[RACObserve(self, stop),
                                                                         RACObserve([GSLocationManager sharedManager], location)]
                                                                reduce:^(NSNumber *direction){
                                                                    return [NSValue valueWithCGAffineTransform:
                                                                            CGAffineTransformMakeRotation(self.stop.nearestEntrance.direction * M_PI / 180 + (3 * M_PI / 4))];
                                                                }];

        RAC(self.stopDistanceLabel, hidden) = [RACObserve([GSLocationManager sharedManager], location) reduceEach:^(id loc){
            return @(loc != nil);
        }];

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
    BOOL locationAvailable = [GSLocationManager sharedManager].location != nil;

    self.stopDistanceLabel.hidden = !locationAvailable;
    self.headingArrow.hidden = !locationAvailable;
    self.distanceContainerView.hidden = !locationAvailable;

    //self.stopDistanceLabel.text = self.stop.nearestEntrance.formattedDistance;
    //self.stopNameLabel.text = self.stop.stop_name;
    //self.detailTextLabel.text = self.stop.subtitle;
    //self.headingArrow.transform = CGAffineTransformMakeRotation(self.stop.nearestEntrance.direction * M_PI / 180 + (3 * M_PI / 4));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
