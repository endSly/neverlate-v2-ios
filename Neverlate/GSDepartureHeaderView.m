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
    self.headingArrow.font = [UIFont iconicFontOfSize:16];
    self.headingArrow.text = icon_navigate;
    
    self.headingArrow.transform = CGAffineTransformMakeRotation(-3.14159265 / 4);
    
    [super layoutSubviews];
}

@end
