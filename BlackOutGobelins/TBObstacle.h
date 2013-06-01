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
-(void) explodeAt:(int)index;
-(NSString *) getUId;
-(int) getIndex;

@end
