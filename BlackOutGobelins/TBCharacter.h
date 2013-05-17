//
//  TBCharacter.h
//  BlackOutGobelins
//
//  Created by tony's computer on 17/05/13.
//
//

#import "CCLayer.h"
#import "TBCharacterFace.h"

@interface TBCharacter : CCLayer
{
    int _directionX;
    int _directionY;
    
    float _inertiaValue;
    float _xIncrement;
    float _yIncrement;
    
    char *_front_animation_name;
    char *_back_animation_name;
    char *_right_animation_name;
    char *_left_animation_name;
    
    TBCharacterFace *_frontFace;
    TBCharacterFace *_backFace;
    TBCharacterFace *_rightFace;
    TBCharacterFace *_leftFace;
    
    TBCharacterFace *_currentFace;
}

- (id)initDefault;
- (id)initWithPrefix:(NSString *)prefix andNumFrame:(int)numFrame;

-(void) changeAnimation:(TBCharacterFace *)animation;
-(void) front;
-(void) back;
-(void) right;
-(void) left;

-(void) drawAt:(CGPoint)pos;
-(CGPoint) getVolumicBoundariesFromPositionTarget:(CGPoint)position;
-(void) walkTo:(CGPoint)position;
-(void) collide;
-(CGPoint) getDirection;
-(void) selectRandomAnimation;
-(CGSize) getSize;

@end
