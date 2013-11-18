//
//  UIColor+HexColor.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 18/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import UIKit;

@interface UIColor (HexColor)

/*
 * Parse CSS colors in hex. Format: #rgb(a); Components can be in 4 o 8 bits.
 */
+ (instancetype)colorWithCSS:(NSString *)css;

@end
