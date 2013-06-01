//
//  TBObstacleFirstType.m
//  BlackOutGobelins
//
//  Created by tony's computer on 31/05/13.
//
//

#import "TBObstacleFirstType.h"

@implementation TBObstacleFirstType

- (id)init
{
    self = [super initWithPrefix:@"obstacle_first"];
    if (self) {
        _activeTransitionFrameNumber = 35;
        _explosionTransitionFrameNumber = 35;
        _inactiveTransitionFrameNumber = 35;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
