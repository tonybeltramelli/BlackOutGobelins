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
    NSString *_pauseTransitionName;
    NSString *_connexionStartTransitionName;
    NSString *_connexionMiddleTransitionName;
    NSString *_deconnexionStartTransitionName;
    NSString *_deconnexionMiddleTransitionName;
    
    int _step;
}

- (id)initDefaultWithPrefix:(NSString *)prefix
{
    self = [super initDefault];
    if (self)
    {
        _pauseTransitionName = [[NSString alloc] initWithFormat:@"%@%@", prefix, @"pause"];
        _connexionStartTransitionName = [[NSString alloc] initWithFormat:@"%@%@", prefix, @"debut_connexion"];
        _connexionMiddleTransitionName = [[NSString alloc] initWithFormat:@"%@%@", prefix, @"milieu_connexion"];
        _deconnexionStartTransitionName = [[NSString alloc] initWithFormat:@"%@%@", prefix, @"debut_deconnexion"];
        _deconnexionMiddleTransitionName = [[NSString alloc] initWithFormat:@"%@%@", prefix, @"milieu_deconnexion"];
        
        _step = 0;
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
    }
    return self;
}

-(void) handleConnection:(BOOL)toConnect
{
    _step = toConnect ? 0 : 2;
    
    [self connectionScheduleHandler:nil];
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
            animation = _connexionStartTransitionName;
            
            firstFrameNumber = _connexionFirstFrameNumber;
            lastFrameNumber = _connexionLastFrameNumber;
            
            toContinue = true;
            break;
        case 2:
            animation = _connexionMiddleTransitionName;
            
            firstFrameNumber = _connexionFirstFrameNumber;
            lastFrameNumber = _connexionLastFrameNumber;
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deconnection:) name:@"STOP_CONNECTION" object:nil];
            
            toContinue = false;
            break;
        case 3:
            animation = _deconnexionStartTransitionName;
            
            firstFrameNumber = _deconnexionStartFirstFrameNumber;
            lastFrameNumber = _deconnexionStartLastFrameNumber;
            
            toContinue = true;
            break;
        case 4:
            animation = _deconnexionMiddleTransitionName;
            
            firstFrameNumber = _deconnexionMiddleFirstFrameNumber;
            lastFrameNumber = _deconnexionMiddleLastFrameNumber;
            
            toContinue = false;
            break;
        default:
            toContinue = false;
            
            _step = 0;
            break;
    }
    
    [_currentFace changeAnimation:animation from:firstFrameNumber to:lastFrameNumber];
    
    if(toContinue) [self schedule:@selector(connectionScheduleHandler:) interval:((lastFrameNumber - firstFrameNumber) * [_frontFace delay])];
}

-(void) deconnection:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self connectionOnRange:false];
    
    _isDeconnected = true;
    
    [self handleConnection:false];
}

@end
