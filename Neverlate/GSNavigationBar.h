//
//  GSNavigationBar.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 13/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

@import UIKit;

@class GSIndeterminatedProgressView;

@interface GSNavigationBar : UINavigationBar {
    UIView *_underlayView;
    
    BOOL _initialized;
}

@property (nonatomic, weak) GSIndeterminatedProgressView *indeterminateProgressView;

- (void)showIndeterminateProgressIndicator;
- (void)hideIndeterminateProgressIndicator;

@end
