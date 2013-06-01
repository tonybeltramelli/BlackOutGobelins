//
//  TBBotSecondState.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 28/05/13.
//
//

#import "TBBotSecondState.h"
#import "TypeDef.c"

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
        
        [self.parent getChildByTag:hero];
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

-(void) update
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
    
    if((arc4random() % 10) < 2)
    {
        _direction = (arc4random() % 4) + 1;
    }else{
        CCLayer *heroRef = (CCLayer *)[self.parent getChildByTag:hero];
        
        int xDirection = self.position.x < heroRef.position.x ? 1 : -1;
        int yDirection = self.position.y < heroRef.position.y ? 1 : -1;
        
        float xVector = (heroRef.position.x - self.position.x) * xDirection;
        float yVector = (heroRef.position.y - self.position.y) * yDirection;
        
        if(xVector > yVector)
        {
            _direction = xDirection > 0 ? 4 : 3;
        }else{
            _direction = yDirection > 0 ? 1 : 2;
        }
    }
       
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
