//
//  TBCharacterTransitionBot.h
//  BlackOutGobelins
//
//  Created by tony's computer on 18/05/13.
//
//

#import "TBCharacter.h"

@interface TBCharacterTransitionBot : TBCharacter
{
    int _pauseTransitionFirstFrameNumber;
    int _pauseTransitionLastFrameNumber;
    
    int _connexionFirstFrameNumber;
    int _connexionLastFrameNumber;
    
    int _deconnexionStartFirstFrameNumber;
    int _deconnexionStartLastFrameNumber;
    
    int _deconnexionMiddleFirstFrameNumber;
    int _deconnexionMiddleLastFrameNumber;
}

- (id)initWithPrefix:(NSString *)prefix andPauseTransitionFirstFrame:(int)startNumber andPauseTransitionLastFrame:(int)endNumber;

@end
