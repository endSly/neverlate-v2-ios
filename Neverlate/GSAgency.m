//
//  GSAgency.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSAgency.h"

#import "UIColor+HexColor.h"

@implementation GSAgency

- (void)setAgency_color:(UIColor *)agency_color
{
    if ([agency_color isKindOfClass:[NSString class]]) {
        agency_color = [UIColor colorWithCSS:(NSString *) agency_color];
    }
    _agency_color = agency_color;
}

@end

@implementation GSAgencyBounds

@end
