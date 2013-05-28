//
//  TBCharacter.m
//  BlackOutGobelins
//
//  Created by tony's computer on 17/05/13.
//
//

#import "TBCharacter.h"
#import "TBConnectionAsset.h"

@implementation TBCharacter
{
    TBConnectionAsset *_connection;
}

- (id)initDefault
{
    self = [super init];
    if (self)
    {
        _frontAnimationName = @"face";
        _backAnimationName = @"dos";
        _rightAnimationName = @"droite";
        _leftAnimationName = @"gauche";
        
        _inertiaValue = 0.5f;
    }
    return self;
}

- (id)initWithPrefix:(NSString *)prefix andNumFrame:(int)numFrame
{
    self = [self initDefault];
    if (self)
    {
        _frontFace = [[TBCharacterFace alloc] initWithNumFrame:numFrame withAnimName:_frontAnimationName andFilePrefix:prefix];
        _backFace = [[TBCharacterFace alloc] initWithNumFrame:numFrame withAnimName:_backAnimationName andFilePrefix:prefix];
        _rightFace = [[TBCharacterFace alloc] initWithNumFrame:numFrame withAnimName:_rightAnimationName andFilePrefix:prefix];
        _leftFace = [[TBCharacterFace alloc] initWithNumFrame:numFrame withAnimName:_leftAnimationName andFilePrefix:prefix];
    }
    return self;
}

-(void) drawAt:(CGPoint)pos
{
    [self setPosition:pos];
    
    [_frontFace drawAt:CGPointZero];
    [_backFace drawAt:CGPointZero];
    [_rightFace drawAt:CGPointZero];
    [_leftFace drawAt:CGPointZero];
    
    [self changeAnimation:_frontFace];
    
    _directionX = 0;
    _directionY = 1;
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
    }
    
    if(position.x != 0)
    {
        _xIncrement = position.x;
    }else{
        if(_currentFace ==  _leftFace)
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
        if(_currentFace ==  _frontFace)
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

-(void) collide
{
    _xIncrement = 0;
    _yIncrement = 0;
}

-(CGPoint) getDirection
{
    if(_currentFace ==  _frontFace) return CGPointMake(0, -1);
    if(_currentFace ==  _backFace) return CGPointMake(0, 1);
    if(_currentFace ==  _rightFace) return CGPointMake(1, 0);
    if(_currentFace ==  _leftFace) return CGPointMake(-1, 0);
    
    return CGPointZero;
}

-(CGPoint) getVolumicBoundariesFromPositionTarget:(CGPoint)position
{
    CGPoint target = CGPointMake([self position].x + position.x, [self position].y + position.y);
    
    int x = [self position].x > target.x ? - 10 : 10;
    int y = [self position].y < target.y ? 0 : -21;
    
    return CGPointMake(x, y);
}

-(void) front
{
    if(_directionY == 1) return;
    
    [self changeAnimation:_frontFace];
    [self frontAnimation];
    
    _directionY = 1;
}

-(void) back
{
    if(_directionY == -1) return;
    
    [self changeAnimation:_backFace];
    [self backAnimation];
    
    _directionY = -1;
}

-(void) right
{
    if(_directionX == 1) return;
    
    [self changeAnimation:_rightFace];
    [self rightAnimation];
    
    _directionX = 1;
}

-(void) left
{
    if(_directionX == -1) return;
    
    [self changeAnimation:_leftFace];
    [self leftAnimation];
    
    _directionX = -1;
}

-(void) frontAnimation { }
-(void) backAnimation { }
-(void) rightAnimation { }
-(void) leftAnimation { }

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
        default:
            [self changeAnimation:_frontFace];
            break;
    }
    
    _currentFace.sprite.opacity = 120.0f;
}

-(void) changeAnimation:(TBCharacterFace *)animation
{
    if(animation == nil) return;
    [self removeAllChildrenWithCleanup:FALSE];
    
    _currentFace = animation;
    [self addChild:_currentFace.sprite];
    
    _connectionAssetPosition = CGPointMake(0, -[_currentFace getHeight]/2);
}

-(void) connectionOnRange:(BOOL)isOnRange
{
    if(!isOnRange || _isDeconnected)
    {
        [self stopConnection:nil];
        return;
    }
    
    if(_isOnRange) return;
    if(_connection) [self stopConnectionAnimationComplete:nil];
    
    _isOnRange = true;
    
    _connection = [[TBConnectionAsset alloc] init];
    [_connection drawAt:_connectionAssetPosition];
    
    [self addChild:_connection z:-1];
}

-(void) startConnection
{
    if(_isOnRange) return;
    
    [self connectionOnRange:true];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopConnection:) name:@"STOP_CONNECTION" object:nil];
}

-(void) stopConnection:(NSNotification *)notification
{
    if(!_connection || !_isOnRange || _isDeconnected) return;
    
    _isOnRange = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopConnectionAnimationComplete:) name:@"STOP_CONNECTION_ANIMATION_COMPLETE" object:nil];
    
    [_connection stopConnection];
}

-(void) stopConnectionAnimationComplete:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self removeChild:_connection cleanup:TRUE];
    
    _connection = nil;
}

-(void) handleConnection:(BOOL)toConnect {}

-(CGSize) getSize
{
    return _currentFace.getSize;
}

- (void)dealloc
{
    [_frontFace release];
    _frontFace = nil;
    
    [_backFace release];
    _backFace = nil;
    
    [_rightFace release];
    _rightFace = nil;
    
    [_leftFace release];
    _leftFace = nil;
    
    [super dealloc];
}

@end
