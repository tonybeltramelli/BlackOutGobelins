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
    self = [super initWithPrefix:@"bot_first_" andPauseTransitionFirstFrame:0 andPauseTransitionLastFrame:24];
    if (self)
    {
        _connectionStartFirstFrameNumber = 0;
        _connectionStartFirstFrameNumber = 24;
        
        _connectionMiddleFirstFrameNumber = 0;
        _connectionMiddleLastFrameNumber = 23;
        
        _disconnectionStartFirstFrameNumber = 4;
        _disconnectionStartLastFrameNumber = 34;
        
        _disconnectionMiddleFirstFrameNumber = 0;
        _disconnectionMiddleLastFrameNumber = 24;
    }
    return self;
}

-(void) connectionOnRange:(BOOL)isOnRange
{
    _connectionAssetPosition = CGPointMake(-3, -[_currentFace getHeight]/4 - 10);
    
    [super connectionOnRange:isOnRange];
}

- (void)dealloc
{
    [super dealloc];
}

@end
