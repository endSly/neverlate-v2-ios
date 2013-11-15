//
//  GSIndeterminatedProgressView.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 15/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSIndeterminatedProgressView.h"

#import "FrameAccessor.h"

const CGFloat CHUNK_WIDTH = 36.0f;

@implementation GSIndeterminatedProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.progressChunks = @[[[UIView alloc] initWithFrame:CGRectMake(-CHUNK_WIDTH, 0, CHUNK_WIDTH, self.height)],
                                [[UIView alloc] initWithFrame:CGRectMake(-CHUNK_WIDTH, 0, CHUNK_WIDTH, self.height)],
                                [[UIView alloc] initWithFrame:CGRectMake(-CHUNK_WIDTH, 0, CHUNK_WIDTH, self.height)]];
        
        for (UIView *v in self.progressChunks) {
            [self addSubview:v];
        }
        
        self.trackTintColor = UIColor.whiteColor;
        self.progressTintColor = UIColor.blueColor;
    }
    return self;
}

- (void)layoutSubviews
{
    NSTimeInterval delay = 0;
    for (UIView *v in self.progressChunks) {
        [self animateProgressChunk:v delay:(delay += 0.25)];
    }
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    _trackTintColor = trackTintColor;
    self.backgroundColor = trackTintColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressTintColor = progressTintColor;
    for (UIView *v in self.progressChunks) {
        v.backgroundColor = progressTintColor;
    }
}

- (void)animateProgressChunk:(UIView *)chunk delay:(NSTimeInterval)delay
{
    [UIView animateWithDuration:0.75 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        chunk.x = self.width;
    } completion:^(BOOL finished) {
        chunk.x = -CHUNK_WIDTH;
        if (finished)
            [self animateProgressChunk:chunk delay:0.4];
    }];
}

@end
