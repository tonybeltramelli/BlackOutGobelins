//
//  TBCharacterTransitionA.h
//  BlackOutGobelins
//
//  Created by tony's computer on 18/05/13.
//
//

#import "TBCharacter.h"

@interface TBCharacterTransitionA : TBCharacter
{
    BOOL _isDeconnected;
}

- (id)initDefaultWithPrefix:(NSString *)prefix;
- (id)initWithPrefix:(NSString *)prefix andPauseTransitionFirstFrame:(int)startNumber andPauseTransitionLastFrame:(int)endNumber;

-(void) connectionOnRange:(BOOL)isOnRange;
-(void) startConnection;

@end
