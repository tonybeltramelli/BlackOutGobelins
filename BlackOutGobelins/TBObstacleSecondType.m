//
//  TBObstacleSecondType.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 31/05/13.
//
//

#import "TBObstacleSecondType.h"

@implementation TBObstacleSecondType

- (id)init
{
    self = [super initWithPrefix:@"obstacle_second"];
    if (self) {
        _activeTransitionFrameNumber = 35;
        _explosionTransitionFrameNumber = 38;
        _inactiveTransitionFrameNumber = 35;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
