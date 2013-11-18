//
//  GSNavigationBar.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSNavigationBar.h"

#import "FrameAccessor.h"
#import "GSIndeterminatedProgressView.h"

@implementation GSNavigationBar

- (void)layoutSubviews
{
    if (!_initialized) {
        GSIndeterminatedProgressView *progressView = [[GSIndeterminatedProgressView alloc] initWithFrame:CGRectMake(0, self.height -2, self.width, 2)];
        progressView.progressTintColor = self.barTintColor;
        progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        progressView.hidden = YES;
        [self addSubview:progressView];
        self.indeterminateProgressView = progressView;
        
        self.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:20],
                                     NSForegroundColorAttributeName: UIColor.whiteColor};
    }
    
    [super layoutSubviews];
    
    if(!_underlayView) {
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
    
    
    self.tintColor = [UIColor whiteColor];
}

- (void)showIndeterminateProgressIndicator
{
    self.indeterminateProgressView.hidden = NO;
}

- (void)hideIndeterminateProgressIndicator
{
    self.indeterminateProgressView.hidden = YES;
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
    _underlayView.backgroundColor = [barTintColor colorWithAlphaComponent:0.5];
    super.barTintColor = [barTintColor colorWithAlphaComponent:0.5];
}

@end
