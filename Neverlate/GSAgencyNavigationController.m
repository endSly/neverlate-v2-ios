//
//  GSNavigationController.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 14/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSAgencyNavigationController.h"

#import <ECSlidingViewController.h>
#import <UIViewController+ECSlidingViewController.h>

#import "GSAgency.h"

#import "GSNavigationBar.h"

@implementation GSAgencyNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOpacity = 0.5f;
    self.view.layer.shadowRadius = 12.0f;
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.frame].CGPath;
    self.view.clipsToBounds = NO;
    
    self.slidingViewController.delegate = self;
    
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
}

- (void)viewDidAppear:(BOOL)animated
{
    GSNavigationBar *navigationBar = (GSNavigationBar *) self.navigationBar;
    navigationBar.opaque = NO;
    navigationBar.barTintColor = [self.agency.agency_color colorWithAlphaComponent:0.8];

    if (!self.agency) {
        self.slidingViewController.anchorRightPeekAmount = -12.0f;
        [self.slidingViewController anchorTopViewToRightAnimated:NO];
    }
}


@end
