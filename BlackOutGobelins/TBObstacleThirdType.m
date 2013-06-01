//
//  TBObstacleThirdType.m
//  BlackOutGobelins
//
//  Created by tony's computer on 31/05/13.
//
//

#import "TBObstacleThirdType.h"

@implementation TBObstacleThirdType

- (id)init
{
    self = [super initWithPrefix:@"obstacle_third"];
    if (self) {
        _activeTransitionFrameNumber = 38;
        _explosionTransitionFrameNumber = 33;
        _inactiveTransitionFrameNumber = 38;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
