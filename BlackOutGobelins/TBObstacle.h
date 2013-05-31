//
//  TBObstacle.h
//  BlackOutGobelins
//
//  Created by tony's computer on 31/05/13.
//
//

#import "TBASets.h"

@interface TBObstacle : TBASets
{
    int _activeTransitionFrameNumber;
    int _explosionTransitionFrameNumber;
    int _inactiveTransitionFrameNumber;
}

-(void) becomeActive;
-(void) explodeAt:(float)delay withId:(int)uid;
-(int) getId;

@end
