//
//  TBBotSecondState.m
//  BlackOutGobelins
//
//  Created by tony's computer on 28/05/13.
//
//

#import "TBBotSecondState.h"

@implementation TBBotSecondState
{
    BOOL _isWalking;
    int _direction;
    int _movementLength;
    int _movementIncrement;
    int _walkUnitStepValue;
}

- (id)init
{
    self = [super initWithPrefix:@"bot_second_" andPauseTransitionFirstFrame:0 andPauseTransitionLastFrame:24];
    if (self)
    {
        _connectionStartFirstFrameNumber = 0;
        _connectionStartFirstFrameNumber = 24;
        
        _connectionMiddleFirstFrameNumber = 0;
        _connectionMiddleLastFrameNumber = 24;
        
        _disconnectionStartFirstFrameNumber = 0;
        _disconnectionStartLastFrameNumber = 24;
        
        _disconnectionMiddleFirstFrameNumber = 0;
        _disconnectionMiddleLastFrameNumber = 24;
        
        _color = ccc3(250, 175, 205); //0xfaafcd
        
        _gravityCenter = CGPointMake(2, -10);
        
        _walkUnitStepValue = 2;
        
        _isWalking = false;
    }
    return self;
}

-(void) connectionOnRange:(BOOL)isOnRange
{
    [super connectionOnRange:isOnRange];
    
    if(!isOnRange || _isDeconnected)
    {
        return;
    }
    
    if(_isWalking) return;
    
    if(!_isWalking)
    {
        _isWalking = true;
        
        [self changeDirection];
    }
}

-(CGPoint) getTargetPosition
{    
    switch (_direction) {
        case 1:
            return CGPointMake(self.position.x, self.position.y - _walkUnitStepValue);
            break;
        case 2:
            return CGPointMake(self.position.x, self.position.y + _walkUnitStepValue);
            break;
        case 3:
            return CGPointMake(self.position.x + _walkUnitStepValue, self.position.y);
            break;
        case 4:
            return CGPointMake(self.position.x - _walkUnitStepValue, self.position.y);
            break;
        default:
            return [super getTargetPosition];
            break;
    }
}

-(void) walk
{
    if(!_isWalking) return;
    
    if((arc4random() % 10) < 5) return;
    
    [self setPosition:[self getTargetPosition]];
    
    _movementIncrement ++;

    if(_movementIncrement == _movementLength)
    {
        _isWalking = false;
    }
}

-(void)changeDirection
{
    _movementLength = 20;
    _movementIncrement = 0;
    
    _direction = (arc4random() % 4) + 1;
    
    NSString *animation;
    
    switch (_direction) {
        case 1:
            animation = _frontAnimationName;
            break;
        case 2:
            animation = _backAnimationName;
            break;
        case 3:
            animation = _rightAnimationName;
            break;
        case 4:
            animation = _leftAnimationName;
            break;
        default:
            animation = _frontAnimationName;
            break;
    }
    
    [_currentFace changeAnimationHard:animation from:0 to:24];
}

- (void)dealloc
{
    [super dealloc];
}

@end
