//
//  GSDepartureHeaderView.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSDepartureHeaderView.h"

#import "UIFont+IonIcons.h"

@implementation GSDepartureHeaderView

- (void)layoutSubviews
{
    self.backgroundColor = UIColor.clearColor;
    
    self.headingArrow.font = [UIFont iconicFontOfSize:16];
    self.headingArrow.text = icon_navigate;
    
    self.headingArrow.transform = CGAffineTransformMakeRotation(-3.14159265 / 4);
    
    [self.menuButton setTitle:icon_navicon forState:UIControlStateNormal];
    self.menuButton.titleLabel.font = [UIFont iconicFontOfSize:32];
    
    [super layoutSubviews];
}

- (void)setHeadingAngle:(float)headingAngle
{
    _headingAngle = headingAngle;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.headingArrow.transform = CGAffineTransformMakeRotation(headingAngle - M_PI / 4);
    });
}

@end
