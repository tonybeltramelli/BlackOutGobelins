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
    
    NSString *_frontAnimationName;
    NSString *_backAnimationName;
    NSString *_rightAnimationName;
    NSString *_leftAnimationName;
    
    TBCharacterFace *_frontFace;
    TBCharacterFace *_backFace;
    TBCharacterFace *_rightFace;
    TBCharacterFace *_leftFace;
    
    TBCharacterFace *_currentFace;
    
    BOOL _isOnRange;
    BOOL _isDeconnected;
    
    CGPoint _connectionAssetPosition;
    CGPoint _gravityCenter;
}

- (id)initDefault;
- (id)initWithPrefix:(NSString *)prefix andNumFrame:(int)numFrame;

-(void) changeAnimation:(TBCharacterFace *)animation;
-(void) front;
-(void) back;
-(void) right;
-(void) left;

-(void) connectionOnRange:(BOOL)isOnRange;
-(void) startConnection;
-(void) handleConnection:(BOOL)toConnect;

-(void) drawAt:(CGPoint)pos;
-(CGPoint) getVolumicBoundariesFromPositionTarget:(CGPoint)position;
-(void) walkTo:(CGPoint)position;
-(void) collide;
-(CGPoint) getDirection;
-(void) selectRandomAnimation;
-(CGSize) getSize;
-(CGPoint) getGravityCenter;

@end
