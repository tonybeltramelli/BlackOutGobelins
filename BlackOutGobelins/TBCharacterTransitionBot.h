//
//  TBCharacterTransitionBot.h
//  BlackOutGobelins
//
//  Created by tony's computer on 18/05/13.
//
//

#import "TBCharacterTransitionA.h"

@interface TBCharacterTransitionBot : TBCharacterTransitionA
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

-(void) handleConnection:(BOOL)toConnect;

@end
