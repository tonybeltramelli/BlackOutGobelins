//
//  TBCharacterTransitionA.m
//  BlackOutGobelins
//
//  Created by tony's computer on 18/05/13.
//
//

#import "TBCharacterTransitionA.h"
#import "TBConnectionAsset.h"

@implementation TBCharacterTransitionA
{
    TBConnectionAsset *_connection;
    
    BOOL _isConnected;
}

- (id)initDefaultWithPrefix:(NSString *)prefix
{
    self = [super initDefault];
    if (self)
    {
        _isConnected = false;
        _isDeconnected = false;
    }
    return self;
}

- (id)initWithPrefix:(NSString *)prefix andPauseTransitionFirstFrame:(int)startNumber andPauseTransitionLastFrame:(int)endNumber
{
    self = [self initDefaultWithPrefix:prefix];
    if (self)
    {
    }
    return self;
}

-(void) connectionOnRange:(BOOL)isOnRange
{
    if(!isOnRange || _isDeconnected)
    {
        [self stopConnection:nil];
        return;
    }
    
    if(_isConnected) return;
    if(_connection) [self stopConnectionAnimationComplete:nil];
    
    _isConnected = true;
    
    _connection = [[TBConnectionAsset alloc] init];
    [_connection drawAt:CGPointMake(0, -[_currentFace getHeight]/2)];
    
    [self addChild:_connection z:-1];
}

-(void) startConnection
{
    if(_isConnected) return;
    
    [self connectionOnRange:true];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopConnection:) name:@"STOP_CONNECTION" object:nil];
}

-(void) stopConnection:(NSNotification *)notification
{
    if(!_connection || !_isConnected || _isDeconnected) return;
    
    _isConnected = false;
    
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

@end
