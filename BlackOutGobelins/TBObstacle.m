//
//  TBObstacle.m
//  BlackOutGobelins
//
//  Created by tony's computer on 31/05/13.
//
//

#import "TBObstacle.h"
#import "TBCharacterFace.h"
#import "TBObstacleFirstType.h"
#import "TBObstacleSecondType.h"
#import "TBObstacleThirdType.h"

@implementation TBObstacle
{
    TBCharacterFace *_activeFace;
    TBCharacterFace *_explosionFace;
    TBCharacterFace *_inactiveFace;
    
    NSString *_activeAnimationName;
    NSString *_explosionAnimationName;
    NSString *_inactiveAnimatioName;
    
    int _step;
    int _index;
    NSString *_uId;
}

- (id)init
{
    self = [TBObstacle obstacle];
    if (self) {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        
        _uId = (NSString *)uuidStringRef;
    }
    return self;
}

+(id)obstacle
{
    int n = (arc4random() % 2) + 1;
    n = 1;
    
    switch (n) {
        case 1:
            return [[[TBObstacleFirstType alloc] init] autorelease];
            break;
        case 2:
            return [[[TBObstacleSecondType alloc] init] autorelease];
            break;
        case 3:
            return [[[TBObstacleThirdType alloc] init] autorelease];
            break;
        default:
            return [[[TBObstacleFirstType alloc] init] autorelease];
            break;
    }
}

- (id)initWithPrefix:(NSString *)prefix
{
    self = [super initWithPrefix:prefix];
    if (self) {
        _activeAnimationName = [[NSString alloc] initWithFormat:@"%@%@", _prefix, @"_actif"];
        _explosionAnimationName = [[NSString alloc] initWithFormat:@"%@%@", _prefix, @"_explosion"];
        _inactiveAnimatioName = [[NSString alloc] initWithFormat:@"%@%@", _prefix, @"_inactif"];
    }
    return self;
}

-(void) drawAt:(CGPoint)pos
{
    _activeFace = [[TBCharacterFace alloc] initWithStartNumFrame:0 andEndNumFrame:_activeTransitionFrameNumber withAnimName:_activeAnimationName andFilePrefix:@""];
    
    _explosionFace = [[TBCharacterFace alloc] initWithStartNumFrame:0 andEndNumFrame:_explosionTransitionFrameNumber withAnimName:_explosionAnimationName andFilePrefix:@""];
    
    _inactiveFace = [[TBCharacterFace alloc] initWithStartNumFrame:0 andEndNumFrame:_inactiveTransitionFrameNumber withAnimName:_inactiveAnimatioName andFilePrefix:@""];
    
    [_activeFace drawAt:CGPointZero];
    [_explosionFace drawAt:CGPointZero];
    [_inactiveFace drawAt:CGPointZero];
    
    _currentFace = _inactiveFace;
    
    [super drawAt:pos];
}

-(void) becomeActive
{
    [self changeFace:_inactiveFace];
}

-(void) explodeAt:(int)index
{
    _index = index;
    _step = 0;
    
    [self schedule:@selector(waitToExplodeDelay:) interval:(index * 0.2f)];
}

-(void) waitToExplodeDelay:(id)sender
{
    [self unschedule:@selector(waitToExplodeDelay:)];
    
    BOOL toContinue;
    
    _step ++;
    
    switch (_step) {
        case 1:
            [self changeFace:_explosionFace];
            
            toContinue = true;
            break;
        case 2:
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"OBSTACLE_DESTROYED_%@", _uId] object:self];
            
            toContinue = false;
            break;
        default:
            _step = 0;
            break;
    }
    
    if(toContinue) [self schedule:@selector(waitToExplodeDelay:) interval:_explosionTransitionFrameNumber * [_currentFace delay]];
}

-(void) changeFace:(TBCharacterFace *)face
{
    [self removeChild:_currentFace.sprite cleanup:TRUE];
    
    _currentFace = face;
    
    [self addChild:_currentFace.sprite];
}

-(NSString *) getUId
{
    return _uId;
}

-(int) getIndex
{
    return _index;
}

- (void)dealloc
{
    [_activeFace release];
    _activeFace = nil;
    
    [_explosionFace release];
    _explosionFace = nil;
    
    [_inactiveFace release];
    _inactiveFace = nil;
    
    [_activeAnimationName release];
    _activeAnimationName = nil;
    
    [_explosionAnimationName release];
    _explosionAnimationName = nil;
    
    [_inactiveAnimatioName release];
    _inactiveAnimatioName = nil;
    
    _uId = nil;
    
    [super dealloc];
}

@end