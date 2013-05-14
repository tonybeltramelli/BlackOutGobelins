//
//  TBCharacter.h
//  BlackOutGobelins
//
//  Created by tony's computer on 09/05/13.
//
//

#import "CCLayer.h"
#import "TBCharacterFace.h"

@interface TBCharacter : CCLayer

-(id)initWithPrefix:(NSString *)prefix;
-(void) drawAt:(CGPoint)pos;
-(CGPoint) getVolumicBoundariesFromPositionTarget:(CGPoint)position;
-(void) walkTo:(CGPoint)position;
-(void) collide;
-(CGPoint) getDirection;
-(void) selectRandomAnimation;
-(CGSize) getSize;

@end
