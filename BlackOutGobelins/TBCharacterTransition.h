//
//  TBCharacterTransition.h
//  BlackOutGobelins
//
//  Created by tony's computer on 17/05/13.
//
//

#import "TBCharacterTransitionA.h"

@interface TBCharacterTransition : TBCharacterTransitionA
{    
    int _startTransitionFirstFrameNumber;
    int _startTransitionLastFrameNumber;
    
    int _endTransitionFirstFrameNumber;
    int _endTransitionLastFrameNumber;
    
    int _middleTransitionFirstFrameNumber;
    int _middleTransitionLastFrameNumber;
    
    int _pauseTransitionFirstFrameNumber;
    int _pauseTransitionLastFrameNumber;
}

-(void) startToWalk;
-(void) setDistanceVectorLength:(double)vectorLength;

@end
