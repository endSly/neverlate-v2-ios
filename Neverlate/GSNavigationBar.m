//
//  GSNavigationBar.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSNavigationBar.h"

@implementation GSNavigationBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if(!_underlayView)
	{
		const CGFloat statusBarHeight = 20;
		const CGSize selfSize = self.frame.size;
        
		_underlayView = [[UIView alloc] initWithFrame:CGRectMake(0, -statusBarHeight, selfSize.width, selfSize.height + statusBarHeight)];
		_underlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_underlayView.backgroundColor = self.barTintColor;
		_underlayView.userInteractionEnabled = NO;
        _underlayView.opaque = NO;
	} else {
        [_underlayView removeFromSuperview];
    }
    
    [self insertSubview:_underlayView atIndex:1];
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
    _underlayView.backgroundColor = [barTintColor colorWithAlphaComponent:0.5];
    super.barTintColor = [barTintColor colorWithAlphaComponent:0.5];
}

@end
