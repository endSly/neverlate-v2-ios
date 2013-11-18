//
//  UIColor+HexColor.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 18/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)

+ (instancetype)colorWithCSS:(NSString*)css {
	if (css == nil || css.length == 0)
		return [UIColor blackColor];
	
	if ([css characterAtIndex:0] == '#')
		css = [css substringFromIndex:1];
	
    NSScanner *scanner = [NSScanner scannerWithString:css];
    
    unsigned int hexColor;
    
    [scanner scanHexInt:&hexColor];

	CGFloat r, g, b, a;
    switch (css.length) {
        case 3:
            a = 1.0f;
            r = ((hexColor >> 8) & 0xF) / ((CGFloat) 0xF);
            g = ((hexColor >> 4) & 0xF) / ((CGFloat) 0xF);
            b = ((hexColor     ) & 0xF) / ((CGFloat) 0xF);
            break;
        case 4:
            r = ((hexColor >> 12) & 0xF) / ((CGFloat) 0xF);
            g = ((hexColor >>  8) & 0xF) / ((CGFloat) 0xF);
            b = ((hexColor >>  4) & 0xF) / ((CGFloat) 0xF);
            a = ((hexColor      ) & 0xF) / ((CGFloat) 0xF);
            break;
        case 6:
            a = 1.0f;
            r = ((hexColor >> 16) & 0xFF) / ((CGFloat) 0xFF);
            g = ((hexColor >>  8) & 0xFF) / ((CGFloat) 0xFF);
            b = ((hexColor      ) & 0xFF) / ((CGFloat) 0xFF);
            break;
        case 8:
            r = ((hexColor >> 24) & 0xFF) / ((CGFloat) 0xFF);
            g = ((hexColor >> 16) & 0xFF) / ((CGFloat) 0xFF);
            b = ((hexColor >>  8) & 0xFF) / ((CGFloat) 0xFF);
            a = ((hexColor      ) & 0xFF) / ((CGFloat) 0xFF);
            break;
    }
    
	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
