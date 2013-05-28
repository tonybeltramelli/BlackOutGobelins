//
//  TBBotThirdState.m
//  BlackOutGobelins
//
//  Created by tony's computer on 28/05/13.
//
//

#import "TBBotThirdState.h"

@implementation TBBotThirdState

- (id)init
{
    self = [super initWithPrefix:@"bot_third_" andPauseTransitionFirstFrame:0 andPauseTransitionLastFrame:24];
    if (self)
    {
        _connectionStartFirstFrameNumber = 0;
        _connectionStartFirstFrameNumber = 24;
        
        _connectionMiddleFirstFrameNumber = 0;
        _connectionMiddleLastFrameNumber = 23;
        
        _disconnectionStartFirstFrameNumber = 0;
        _disconnectionStartLastFrameNumber = 19;
        
        _disconnectionMiddleFirstFrameNumber = 0;
        _disconnectionMiddleLastFrameNumber = 24;
        
        _color = ccc3(116, 224, 255); //0x74e0ff
        
        _gravityCenter = CGPointMake(4, -10);
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
