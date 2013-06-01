//
//  TBBotFirstState.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 15/05/13.
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
        
        _color = ccc3(125, 255, 140); //0x7dff8c
        
        _gravityCenter = CGPointMake(-3, -10);
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
