//
//  UIBarButtonItem+IonIcons.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 20/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "UIBarButtonItem+IonIcons.h"

@implementation UIBarButtonItem (IonIcons)

- (id)initWithIcon:(NSString *)icon target:(id)target action:(SEL)action
{
    self = [self initWithTitle:icon style:UIBarButtonItemStylePlain target:target action:action];
    
    if (self) {
        [self setTitleTextAttributes:@{NSFontAttributeName: [UIFont iconicFontOfSize:32]}
                            forState:UIControlStateNormal];
    }

    return self;
}

@end
