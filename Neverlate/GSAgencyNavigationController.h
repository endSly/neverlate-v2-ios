//
//  GSNavigationController.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 14/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSNavigationController.h"

#import <ECSlidingViewController.h>

@class GSAgency;

@interface GSAgencyNavigationController : GSNavigationController <ECSlidingViewControllerDelegate>

@property (nonatomic, strong) GSAgency  * agency;

@end
