//
//  GSSlidingAnimationTransitioning.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 18/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSSlidingAnimationTransitioning.h"

#import <ECSlidingViewController.h>

@implementation GSSlidingAnimationTransitioning

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *topViewController = [transitionContext viewControllerForKey:ECTransitionContextTopViewControllerKey];
    UIViewController *toViewController  = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    CGRect topViewFinalFrame   = [transitionContext finalFrameForViewController:topViewController];
    
    if (topViewController != toViewController) {
        CGRect toViewInitialFrame = [transitionContext initialFrameForViewController:toViewController];
        toViewController.view.frame = toViewInitialFrame;
        [containerView insertSubview:toViewController.view belowSubview:topViewController.view];
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        topViewController.view.frame = topViewFinalFrame;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            topViewController.view.frame = [transitionContext initialFrameForViewController:topViewController];
        }

        [transitionContext completeTransition:finished];
    }];
}

@end
