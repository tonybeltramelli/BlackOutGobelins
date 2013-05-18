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
        _connexionFirstFrameNumber = 0;
        _connexionLastFrameNumber = 24;
        
        _deconnexionStartFirstFrameNumber = 0;
        _deconnexionStartLastFrameNumber = 29;
        
        _deconnexionMiddleFirstFrameNumber = 0;
        _deconnexionMiddleLastFrameNumber = 24;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
