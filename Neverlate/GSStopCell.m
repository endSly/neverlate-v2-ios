//
//  GSStopCell.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSStopCell.h"

#import "UIFont+IonIcons.h"

#import "GSStop.h"

@implementation GSStopCell

- (void)layoutSubviews
{
    self.headingArrow.font = [UIFont iconicFontOfSize:16];
    self.headingArrow.text = icon_navigate;
    
    self.headingArrow.transform = CGAffineTransformMakeRotation(-3.14159265 / 4);
    
    
}

- (void)setStop:(GSStop *)stop
{
    _stop = stop;
    self.stopDistanceLabel.text = stop.formattedDistance;
    self.stopNameLabel.text = stop.stop_name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
