//
//  GSRoute.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSRoute.h"

#import "UIColor+HexColor.h"

@implementation GSRoute

- (void)setRoute_color:(UIColor *)route_color
{
    if ([route_color isKindOfClass:[NSString class]]) {
        route_color = [UIColor colorWithCSS:(NSString *) route_color];
    }
    _route_color = route_color;
}

@end
