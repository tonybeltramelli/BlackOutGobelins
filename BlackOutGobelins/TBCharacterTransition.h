//
//  TBCharacterTransition.h
//  BlackOutGobelins
//
//  Created by tony's computer on 17/05/13.
//
//

#import "TBCharacter.h"

@interface TBCharacterTransition : TBCharacter
{
    NSString *_startTransitionName;
    NSString *_endTransitionName;
    NSString *_middleTransitionName;
    NSString *_pauseTransitionName;
    
    int _startTransitionFirstFrameNumber;
    int _startTransitionLastFrameNumber;
    
    int _endTransitionFirstFrameNumber;
    int _endTransitionLastFrameNumber;
    
    int _middleTransitionFirstFrameNumber;
    int _middleTransitionLastFrameNumber;
    
    int _pauseTransitionFirstFrameNumber;
    int _pauseTransitionLastFrameNumber;
}

- (id)initDefaultWithPrefix:(NSString *)prefix;
- (id)initWithPrefix:(NSString *)prefix andPauseTransitionFirstFrame:(int)startNumber andPauseTransitionLastFrame:(int)endNumber;

-(void) startToWalk;
-(void) setDistanceVectorLength:(double)vectorLength;;

@end
