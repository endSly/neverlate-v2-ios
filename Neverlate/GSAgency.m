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

- (MKCoordinateRegion)region
{
    CLLocationCoordinate2D center = self.agency_center.CLLocation.coordinate;
    CLLocationCoordinate2D ne = self.agency_bounds.ne.CLLocation.coordinate;
    CLLocationCoordinate2D sw = self.agency_bounds.sw.CLLocation.coordinate;
    
    return MKCoordinateRegionMake(center, MKCoordinateSpanMake(ne.latitude - sw.latitude, ne.longitude - sw.longitude));
}

@end

@implementation GSAgencyBounds

@end
