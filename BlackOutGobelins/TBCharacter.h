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
{
    char *_front_animation_name;
    char *_back_animation_name;
    char *_right_animation_name;
    char *_left_animation_name;
    char *_back_right_animation_name;
    char *_back_left_animation_name;
    char *_front_right_animation_name;
    char *_front_left_animation_name;
    
    TBCharacterFace *_frontFace;
    TBCharacterFace *_backFace;
    TBCharacterFace *_rightFace;
    TBCharacterFace *_leftFace;
    TBCharacterFace *_backRightFace;
    TBCharacterFace *_backLeftFace;
    TBCharacterFace *_frontRightFace;
    TBCharacterFace *_frontLeftFace;
}

- (id)initDefault;
- (id)initWithPrefix:(NSString *)prefix andNumFrame:(int)numFrame;

-(void) drawAt:(CGPoint)pos;
-(CGPoint) getVolumicBoundariesFromPositionTarget:(CGPoint)position;
-(void) walkTo:(CGPoint)position;
-(void) collide;
-(CGPoint) getDirection;
-(void) selectRandomAnimation;
-(CGSize) getSize;

@end
