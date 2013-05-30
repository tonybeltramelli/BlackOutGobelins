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
    
    int _connectionStartFirstFrameNumber;
    int _connectionStartLastFrameNumber;
    
    int _connectionMiddleFirstFrameNumber;
    int _connectionMiddleLastFrameNumber;
    
    int _disconnectionStartFirstFrameNumber;
    int _disconnectionStartLastFrameNumber;
    
    int _disconnectionMiddleFirstFrameNumber;
    int _disconnectionMiddleLastFrameNumber;
    
    ccColor3B _color;
}

- (id)initWithPrefix:(NSString *)prefix andPauseTransitionFirstFrame:(int)startNumber andPauseTransitionLastFrame:(int)endNumber;

-(void)changeDirection;
-(void) update;
-(BOOL) isConnectable;
-(ccColor3B) getColor;
-(CGPoint) getTargetPosition;

@end
