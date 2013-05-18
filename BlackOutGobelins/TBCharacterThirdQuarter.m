//
//  TBCharacter.m
//  BlackOutGobelins
//
//  Created by tony's computer on 09/05/13.
//
//

#import "TBCharacterThirdQuarter.h"

@implementation TBCharacterThirdQuarter

- (id)initDefault
{
    self = [super initDefault];
    if (self)
    {
        _backRightAnimationName = @"34dos_droite";
        _backLeftAnimationName = @"34dos_gauche";
        _frontRightAnimationName = @"34face_droite";
        _frontLeftAnimationName = @"34face_gauche";
    }
    return self;
}

- (id)initWithPrefix:(NSString *)prefix andNumFrame:(int)numFrame
{
    self = [super initWithPrefix:prefix andNumFrame:numFrame];
    if (self)
    {
        _backRightFace = [[TBCharacterFace alloc] initWithNumFrame:numFrame withAnimName:_backRightAnimationName andFilePrefix:prefix];
        _backLeftFace = [[TBCharacterFace alloc] initWithNumFrame:numFrame withAnimName:_backLeftAnimationName andFilePrefix:prefix];
        _frontRightFace = [[TBCharacterFace alloc] initWithNumFrame:numFrame withAnimName:_frontRightAnimationName andFilePrefix:prefix];
        _frontLeftFace = [[TBCharacterFace alloc] initWithNumFrame:numFrame withAnimName:_frontLeftAnimationName andFilePrefix:prefix];
    }
    return self;
}

-(void) drawAt:(CGPoint)pos
{
    [_backRightFace drawAt:CGPointZero];
    [_backLeftFace drawAt:CGPointZero];
    [_frontRightFace drawAt:CGPointZero];
    [_frontLeftFace drawAt:CGPointZero];
    
    [super drawAt:pos];
}

-(void) walkTo:(CGPoint)position
{
    CGPoint target = CGPointMake([self position].x + position.x, [self position].y + position.y);
    
    CGPoint diff = CGPointMake(target.x - [self position].x, target.y - [self position].y);
    CGPoint gap = CGPointMake(diff.x < 0 ? diff.x * -1 : diff.x, diff.y < 0 ? diff.y * -1 : diff.y);
    
    if(gap.x < 0.01 && gap.y < 0.01)
    {
        _directionX = _directionY = 0;
    }else{
        if(gap.x > gap.y)
        {
            _directionY = 0;
            
            if([self position].x > target.x)
            {
                [self left];
            }else if([self position].x < target.x){
                [self right];
            }
        }else{
            _directionX = 0;
            
            if([self position].y > target.y)
            {
                [self front];
            }else if([self position].y < target.y){
                [self back];
            }
        }
        
        if(gap.x == gap.y)
        {
            _directionX = _directionY = 0;
            
            if([self position].x > target.x)
            {
                if([self position].y > target.y)
                {
                    [self frontLeft];
                }else if([self position].y < target.y){
                    [self backLeft];
                }
            }else if([self position].x < target.x){
                if([self position].y > target.y)
                {
                    [self frontRight];
                }else if([self position].y < target.y){
                    [self backRight];
                }
            }
        }
    }
    
    if(position.x != 0)
    {
        _xIncrement = position.x;
    }else{
        if(_currentFace ==  _leftFace || _currentFace ==  _backLeftFace || _currentFace ==  _frontLeftFace)
        {
            if(_xIncrement < 0)
            {
                _xIncrement += _inertiaValue;
            }else{
                _xIncrement = 0;
            }
        }else{
            if(_xIncrement > 0)
            {
                _xIncrement -= _inertiaValue;
            }else{
                _xIncrement = 0;
            }
        }
    }
    
    if(position.y != 0)
    {
        _yIncrement = position.y;
    }else{
        if(_currentFace ==  _frontFace || _currentFace ==  _frontLeftFace || _currentFace ==  _frontRightFace)
        {
            if(_yIncrement < 0)
            {
                _yIncrement += _inertiaValue;
            }else{
                _yIncrement = 0;
            }
        }else{
            if(_yIncrement > 0)
            {
                _yIncrement -= _inertiaValue;
            }else{
                _yIncrement = 0;
            }
        }
    }
    
    CGPoint realTarget = CGPointMake([self position].x + _xIncrement, [self position].y + _yIncrement);
    
    [self setPosition:realTarget];
}

-(CGPoint) getDirection
{
    if(_currentFace ==  _frontFace) return CGPointMake(0, -1);
    if(_currentFace ==  _backFace) return CGPointMake(0, 1);
    if(_currentFace ==  _rightFace) return CGPointMake(1, 0);
    if(_currentFace ==  _leftFace) return CGPointMake(-1, 0);
    if(_currentFace ==  _frontRightFace) return CGPointMake(1, -1);
    if(_currentFace ==  _frontLeftFace) return CGPointMake(-1, -1);
    if(_currentFace ==  _backRightFace) return CGPointMake(1, 1);
    if(_currentFace ==  _backLeftFace) return CGPointMake(-1, 1);
    return CGPointZero;
}

-(void) frontLeft
{
    if(_directionY == 1 && _directionX == -1) return;
    
    [self changeAnimation:_frontLeftFace];
    
    _directionY = 1;
    _directionX = -1;
}

-(void) backLeft
{
    if(_directionY == -1 && _directionX == -1) return;
    
    [self changeAnimation:_backLeftFace];
    
    _directionY = -1;
    _directionX = -1;
}

-(void) frontRight
{
    if(_directionY == 1 && _directionX == 1) return;
    
    [self changeAnimation:_frontRightFace];
    
    _directionY = 1;
    _directionX = 1;
}

-(void) backRight
{
    if(_directionY == -1 && _directionX == 1) return;
    
    [self changeAnimation:_backRightFace];
    
    _directionY = -1;
    _directionX = 1;
}

-(void) selectRandomAnimation
{
    int n = (arc4random() % 5) + 1;
    
    switch (n) {
        case 1:
            [self changeAnimation:_frontFace];
            break;
        case 2:
            [self changeAnimation:_backFace];
            break;
        case 3:
            [self changeAnimation:_rightFace];
            break;
        case 4:
            [self changeAnimation:_leftFace];
            break;
        case 5:
            [self changeAnimation:_frontLeftFace];
            break;
        case 6:
            [self changeAnimation:_backLeftFace];
            break;
        case 7:
            [self changeAnimation:_frontRightFace];
            break;
        case 8:
            [self changeAnimation:_backRightFace];
            break;
        default:
            [self changeAnimation:_frontFace];
            break;
    }
    
    _currentFace.sprite.opacity = 120.0f;
}

- (void)dealloc
{
    [_backRightFace release];
    _backRightFace = nil;
    
    [_backLeftFace release];
    _backLeftFace = nil;
    
    [_frontRightFace release];
    _frontRightFace = nil;
    
    [_frontLeftFace release];
    _frontLeftFace = nil;
    
    [super dealloc];
}

@end
