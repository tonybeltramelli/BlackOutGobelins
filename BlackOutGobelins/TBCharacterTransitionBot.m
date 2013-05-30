//
//  TBCharacterTransitionBot.m
//  BlackOutGobelins
//
//  Created by tony's computer on 18/05/13.
//
//

#import "TBCharacterTransitionBot.h"
#import "TBConnectionAsset.h"

@implementation TBCharacterTransitionBot
{    
    NSString *_connectionStartTransitionName;
    NSString *_connectionMiddleTransitionName;
    NSString *_disconnectionStartTransitionName;
    NSString *_disconnectionMiddleTransitionName;
    
    TBCharacterFace *_pauseFace;
    TBCharacterFace *_connectionFace;
    TBCharacterFace *_disconnectionFace;
    
    int _step;
}

- (id)initDefaultWithPrefix:(NSString *)prefix
{
    self = [super initDefault];
    if (self)
    {
        _frontAnimationName = [[NSString alloc] initWithFormat:@"%@%@", prefix, _frontAnimationName];
        _backAnimationName = [[NSString alloc] initWithFormat:@"%@%@", prefix, _backAnimationName];
        _rightAnimationName = [[NSString alloc] initWithFormat:@"%@%@", prefix, _rightAnimationName];
        _leftAnimationName = [[NSString alloc] initWithFormat:@"%@%@", prefix, _leftAnimationName];
        
        _connectionStartTransitionName = [[NSString alloc] initWithFormat:@"%@%@", prefix, @"connexion"];
        _connectionMiddleTransitionName = [[NSString alloc] initWithFormat:@"%@%@", prefix, @"connexion_loop"];
        _disconnectionStartTransitionName = [[NSString alloc] initWithFormat:@"%@%@", prefix, @"disconnexion"];
        _disconnectionMiddleTransitionName = [[NSString alloc] initWithFormat:@"%@%@", prefix, @"disconnexion_loop"];
        
        _step = 0;
        _color = ccc3(146, 236, 255); //0x92ecff
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
        
        _pauseFace = [[TBCharacterFace alloc] initWithStartNumFrame:_pauseTransitionFirstFrameNumber andEndNumFrame:_pauseTransitionLastFrameNumber withAnimName:_frontAnimationName andFileName:@"" andFilePrefix:[NSString stringWithFormat:@"%@pause", prefix]];
    }
    return self;
}

-(void) drawAt:(CGPoint)pos
{    
    [super drawAt:pos];
    
    _connectionFace = [[TBCharacterFace alloc] initWithStartNumFrame:_connectionStartFirstFrameNumber andEndNumFrame:_connectionStartLastFrameNumber withAnimName:_connectionStartTransitionName andFileName:_connectionStartTransitionName andFilePrefix:@""];
    
    _disconnectionFace = [[TBCharacterFace alloc] initWithStartNumFrame:_disconnectionStartFirstFrameNumber andEndNumFrame:_disconnectionStartLastFrameNumber withAnimName:_disconnectionStartTransitionName andFileName:_disconnectionStartTransitionName andFilePrefix:@""];
    
    [_pauseFace drawAt:CGPointZero];
    [_connectionFace drawAt:CGPointZero];
    [_disconnectionFace drawAt:CGPointZero];
    
    [self changeAnimation:_pauseFace];
}

-(void) handleConnection:(BOOL)toConnect
{
    _step = toConnect ? 0 : 2;
    
    [self connectionScheduleHandler:nil];
    [super handleConnection:toConnect];
}

-(void) connectionScheduleHandler:(id)sender
{
    [self unschedule:@selector(connectionScheduleHandler:)];
    
    NSString *animation;
    
    int firstFrameNumber;
    int lastFrameNumber;
    
    BOOL toContinue = false;
    
    _step ++;
    
    switch (_step) {
        case 1:
            [self changeAnimation:_connectionFace];
            
            animation = _connectionStartTransitionName;
            
            firstFrameNumber = _connectionStartFirstFrameNumber;
            lastFrameNumber = _connectionStartLastFrameNumber;
            
            toContinue = true;
            break;
        case 2:
            [self changeAnimation:_connectionFace];
            
            animation = _connectionMiddleTransitionName;
            
            firstFrameNumber = _connectionMiddleFirstFrameNumber;
            lastFrameNumber = _connectionMiddleLastFrameNumber;
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnection:) name:@"STOP_CONNECTION" object:nil];
            
            toContinue = false;
            break;
        case 3:
            [self changeAnimation:_disconnectionFace];
            
            animation = _disconnectionStartTransitionName;
            
            firstFrameNumber = _disconnectionStartFirstFrameNumber;
            lastFrameNumber = _disconnectionStartLastFrameNumber;
            
            toContinue = true;
            break;
        case 4:
            [self changeAnimation:_disconnectionFace];
            
            animation = _disconnectionMiddleTransitionName;
            
            firstFrameNumber = _disconnectionMiddleFirstFrameNumber;
            lastFrameNumber = _disconnectionMiddleLastFrameNumber;
            
            toContinue = false;
            break;
        default:
            toContinue = false;
            
            _step = 0;
            break;
    }
    
    [_currentFace changeAnimationHard:animation from:firstFrameNumber to:lastFrameNumber];
    
    if(toContinue) [self schedule:@selector(connectionScheduleHandler:) interval:((lastFrameNumber - firstFrameNumber) * [_frontFace delay])];
}

-(void) disconnection:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self connectionOnRange:false];
    
    _isDeconnected = true;
    
    [self handleConnection:false];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BOT_DISCONNECTED" object:self];
}

-(void) connectionOnRange:(BOOL)isOnRange
{
    _connectionAssetPosition = CGPointMake(_gravityCenter.x, _gravityCenter.y - [_currentFace getHeight] / 4);
    
    [super connectionOnRange:isOnRange];
}

-(BOOL) isConnectable
{
    return _isOnRange && !_isDeconnected;
}

-(void)changeDirection {}

-(void) update {}

-(CGPoint) getTargetPosition
{
    return self.position;;
}

-(ccColor3B) getColor
{
    return _color;
}

@end
