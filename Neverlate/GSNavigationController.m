//
//  GSNavigationController.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 14/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSNavigationController.h"

#import <UIViewController+ECSlidingViewController.h>

#import "GSSlidingAnimationTransitioning.h"

@interface GSNavigationController ()

@end

@implementation GSNavigationController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOpacity = 0.5f;
    self.view.layer.shadowRadius = 12.0f;
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.frame].CGPath;
    self.view.clipsToBounds = NO;
    
    self.slidingViewController.delegate = self;
    
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - ECSlidingViewController delegate

- (id<UIViewControllerAnimatedTransitioning>)slidingViewController:(ECSlidingViewController *)slidingViewController
                                   animationControllerForOperation:(ECSlidingViewControllerOperation)operation
                                                 topViewController:(UIViewController *)topViewController
{
    return [[GSSlidingAnimationTransitioning alloc] init];
}


@end
