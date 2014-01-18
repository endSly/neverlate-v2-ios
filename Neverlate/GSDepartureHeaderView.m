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
    if (!_initialized) {
        _initialized = YES;
        
        self.backgroundColor = UIColor.clearColor;
        
        self.headingArrow.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.headingArrow.clipsToBounds = NO;

        [self.menuButton setTitle:icon_navicon forState:UIControlStateNormal];
        self.menuButton.titleLabel.font = [UIFont iconicFontOfSize:32];
    }
    
    [super layoutSubviews];
}

- (void)setHeadingAngle:(CGFloat)headingAngle
{
    _headingAngle = headingAngle;
    self.headingArrow.layer.affineTransform = CGAffineTransformMakeRotation(headingAngle);
}

@end
