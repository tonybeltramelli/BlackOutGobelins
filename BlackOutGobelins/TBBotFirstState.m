//
//  TBBotFirstState.m
//  BlackOutGobelins
//
//  Created by tony's computer on 15/05/13.
//
//

#import "TBBotFirstState.h"

@implementation TBBotFirstState

- (id)init
{
    self = [self initWithPrefix:@"bot_first_" andPauseTransitionFirstFrame:0 andPauseTransitionLastFrame:24];
    if (self)
    {
    }
    return self;
}

- (id)initWithPrefix:(NSString *)prefix andPauseTransitionFirstFrame:(int)startNumber andPauseTransitionLastFrame:(int)endNumber
{
    self = [super initDefaultWithPrefix:prefix];
    if (self)
    {        
        _pauseTransitionFirstFrameNumber = startNumber;
        _pauseTransitionLastFrameNumber = endNumber;
        
        _frontFace = [[TBCharacterFace alloc] initWithStartNumFrame:_pauseTransitionFirstFrameNumber andEndNumFrame:_pauseTransitionLastFrameNumber withAnimName:_pauseTransitionName andFileName:_frontAnimationName andFilePrefix:prefix];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
