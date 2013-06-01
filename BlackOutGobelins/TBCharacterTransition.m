//
//  TBCharacterTransition.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 17/05/13.
//
//

#import "TBCharacterTransition.h"
#import "TBConnectionAsset.h"

@implementation TBCharacterTransition
{
    NSString *_startTransitionName;
    NSString *_endTransitionName;
    NSString *_middleTransitionName;
    NSString *_pauseTransitionName;
    
    int _step;
    double _vectorLength;
}

const int LIMIT_VECTOR_LENGTH = 100;

- (id)initDefaultWithPrefix:(NSString *)prefix
{
    self = [super initDefault];
    if (self)
    {
        _startTransitionName = [[NSString alloc] initWithFormat:@"%@%@", prefix, @"debut"];
        _endTransitionName = [[NSString alloc] initWithFormat:@"%@%@", prefix, @"fin"];
        _middleTransitionName = [[NSString alloc] initWithFormat:@"%@%@", prefix, @"milieu"];
        _pauseTransitionName = [[NSString alloc] initWithFormat:@"%@%@", prefix, @"pause"];
        
        _step = 0;
        _vectorLength = 0.0;
    }
    return self;
}

- (id)initWithPrefix:(NSString *)prefix andPauseTransitionFirstFrame:(int)startNumber andPauseTransitionLastFrame:(int)endNumber
{
    self = [self initDefaultWithPrefix:prefix];
    if (self)
    {
        _pauseTransitionFirstFrameNumber = startNumber;
        _pauseTransitionLastFrameNumber = endNumber;
        
        _frontFace = [[TBCharacterFace alloc] initWithStartNumFrame:_pauseTransitionFirstFrameNumber andEndNumFrame:_pauseTransitionLastFrameNumber withAnimName:_pauseTransitionName andFileName:_frontAnimationName andFilePrefix:prefix];
        
        _backFace = [[TBCharacterFace alloc] initWithStartNumFrame:_pauseTransitionFirstFrameNumber andEndNumFrame:_pauseTransitionLastFrameNumber withAnimName:_pauseTransitionName andFileName:_backAnimationName andFilePrefix:prefix];
        
        _rightFace = [[TBCharacterFace alloc] initWithStartNumFrame:_pauseTransitionFirstFrameNumber andEndNumFrame:_pauseTransitionLastFrameNumber withAnimName:_pauseTransitionName andFileName:_rightAnimationName andFilePrefix:prefix];
        
        _leftFace = [[TBCharacterFace alloc] initWithStartNumFrame:_pauseTransitionFirstFrameNumber andEndNumFrame:_pauseTransitionLastFrameNumber withAnimName:_pauseTransitionName andFileName:_leftAnimationName andFilePrefix:prefix];
    }
    return self;
}

-(void) startToWalk
{
    _step = 0;
    
    if(_vectorLength < LIMIT_VECTOR_LENGTH)
    {
        [_currentFace changeAnimation:_pauseTransitionName from:_pauseTransitionFirstFrameNumber to:_pauseTransitionLastFrameNumber];
        return;
    }
    
    [self walkingScheduleHandler:nil];
}

-(void) walkingScheduleHandler:(id)sender
{
    [self unschedule:@selector(walkingScheduleHandler:)];
    
    NSString *animation;
    
    int firstFrameNumber;
    int lastFrameNumber;
    
    BOOL toContinue = false;
    
    _step ++;
    
    switch (_step) {
        case 1:
            animation = _startTransitionName;
            
            firstFrameNumber = _startTransitionFirstFrameNumber;
            lastFrameNumber = _startTransitionLastFrameNumber;
            
            toContinue = true;
            break;
        case 2:
            animation = _middleTransitionName;
            
            firstFrameNumber = _middleTransitionFirstFrameNumber;
            lastFrameNumber = _middleTransitionLastFrameNumber;
            
            toContinue = true;
            break;
        case 3:
            animation = _endTransitionName;
            
            firstFrameNumber = _endTransitionFirstFrameNumber;
            lastFrameNumber = _endTransitionLastFrameNumber;
            
            toContinue = true;
            break;
        case 4:
            animation = _pauseTransitionName;
            
            firstFrameNumber = _pauseTransitionFirstFrameNumber;
            lastFrameNumber = _pauseTransitionLastFrameNumber;
            
            toContinue = false;
            
            _step = 0;
            break;
        default:
            toContinue = false;
            
            _step = 0;
            break;
    }
    
    [_currentFace changeAnimation:animation from:firstFrameNumber to:lastFrameNumber];
    
    if(toContinue) [self schedule:@selector(walkingScheduleHandler:) interval:((lastFrameNumber - firstFrameNumber) * [_frontFace delay])];
}

-(void)setDistanceVectorLength:(double)vectorLength
{
    _vectorLength = vectorLength;
}

- (void)dealloc
{
    [_startTransitionName release];
    _startTransitionName = nil;
    
    [_endTransitionName release];
    _endTransitionName = nil;
    
    [_middleTransitionName release];
    _middleTransitionName = nil;
    
    [_pauseTransitionName release];
    _pauseTransitionName = nil;
    
    [super dealloc];
}

@end
