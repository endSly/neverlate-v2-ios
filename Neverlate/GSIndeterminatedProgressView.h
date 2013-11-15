//
//  GSIndeterminatedProgressView.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 15/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSIndeterminatedProgressView : UIView {
    BOOL _initialized;
}

@property (nonatomic, strong) NSArray   * progressChunks;

@property (nonatomic, strong) UIColor   * progressTintColor;
@property (nonatomic, strong) UIColor   * trackTintColor;

@end
