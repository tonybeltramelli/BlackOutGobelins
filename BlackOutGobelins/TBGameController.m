//
//  TBGameController.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 01/05/13.
//
//

#import "TBGameController.h"

#import "cocos2d.h"
#import "TBJoystick.h"
#import "TBTouchFeedback.h"
#import "TypeDef.c"

@implementation TBGameController
{
    CCLayer *_layer;
    TBJoystick *_joystick;
    TBHeroFirstState *_hero;
    
    CGSize _size;
    BOOL _useJoystick;
    BOOL _useTouch;
    float _xIncrement;
    float _yIncrement;
    float _frame;
}

const int ANIMATION_TIME = 62.00; //in frame number

- (id)initInLayer:(CCLayer *)layer withHero:(TBHeroFirstState *)hero
{
    self = [super init];
    if (self)
    {
        _layer = layer;
        _hero = hero;
        
        #ifdef __CC_PLATFORM_IOS
            _layer.isTouchEnabled = YES;
        #elif defined(__CC_PLATFORM_MAC)
            _layer.isMouseEnabled = YES;
        #endif
        
        _size = [[CCDirector sharedDirector] winSize];
        
        _useJoystick = _useTouch = FALSE;
    }
    return self;
}

- (void)useJoystick:(BOOL)useIt
{
    _useJoystick = useIt;
    _useTouch = !_useJoystick;
    
    if(_useJoystick)
    {
        _joystick = [[TBJoystick alloc] initWithIsCenterWithTouchEnd:TRUE];
        [_joystick setLocation:CGPointMake(-_size.width + _joystick.size.width + 32, 0)];
        
        [_layer addChild:_joystick z:2];
    }else{
        [_layer removeChild:_joystick cleanup:TRUE];
        
        [_joystick release];
        _joystick = nil;
    }
}

- (void)useTouch:(BOOL)useIt
{
    _useTouch = useIt;
    
    [self useJoystick:!_useTouch];
}

- (CGPoint)getTargetPosition
{
    if(_useJoystick)
    {        
        if(_joystick.isPressed)
        {
            return CGPointMake(round([_joystick values].x) * 2.0, round([_joystick values].y) * 2.0);
        }
    }
    
    if(_useTouch)
    {
        if(_frame <= ANIMATION_TIME)
        {
            _frame ++;
            
            return CGPointMake(_xIncrement, _yIncrement);
        }
    }
    
    return CGPointZero;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_useTouch)
    {
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView: [touch view]];
        location = [[CCDirector sharedDirector] convertToGL: location];
        
        float xTarget = location.x - _size.width / 2;
        float yTarget = location.y - _size.height / 2;
        
        CGPoint startPosition = _hero.position;
        CGPoint endPosition = CGPointMake(_hero.position.x + xTarget, _hero.position.y + yTarget);
        
        int xDirection = startPosition.x < endPosition.x ? 1 : -1;
        int yDirection = startPosition.y < endPosition.y ? 1 : -1;
        
        float xVector = (endPosition.x - startPosition.x) * xDirection;
        float yVector = (endPosition.y - startPosition.y) * yDirection;
        
        double vectorLength = sqrt(pow(xVector,2) + pow(yVector,2));
        
        [_hero setDistanceVectorLength:vectorLength];
        
        _xIncrement = (xVector / ANIMATION_TIME) * xDirection;
        _yIncrement = (yVector / ANIMATION_TIME) * yDirection;
        
        _frame = 0;
        
        TBTouchFeedback *touchFeedBack = [TBTouchFeedback touchFeedback];
        [touchFeedBack setPosition:CGPointMake(endPosition.x, endPosition.y)];
        [[_hero.parent.parent getChildByTag:topContainer] addChild:touchFeedBack];
    }
}

- (BOOL)doNeedToIgnoreTouchAction
{
    return _useJoystick && _joystick.isPressed;
}

- (void)dealloc
{
    if(_useJoystick)
    {
        [_layer removeChild:_joystick cleanup:TRUE];
        
        [_joystick release];
        _joystick = nil;
    }
    
    [super dealloc];
}

@end
