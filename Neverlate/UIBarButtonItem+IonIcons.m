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
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    button.titleLabel.font = [UIFont iconicFontOfSize:32];
    [button setTitle:icon forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return [self initWithCustomView:button];
}

@end
