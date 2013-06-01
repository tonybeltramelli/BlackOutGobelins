//
//  TBAPlant.m
//  BlackOutGobelins
//
//  Created by tony's computer on 31/05/13.
//
//

#import "TBAPlant.h"
#import "TBCharacterFace.h"

@implementation TBAPlant
{
    TBCharacterFace *_startFace;
    TBCharacterFace *_loopFace;
    
    NSString *_startAnimationName;
    NSString *_loopAnimationName;
}

- (id)initWithPrefix:(NSString *)prefix
{
    self = [super initWithPrefix:prefix];
    if (self) {
        _startAnimationName = [[NSString alloc] initWithFormat:@"%@%@", _prefix, @"_debut"];
        _loopAnimationName = [[NSString alloc] initWithFormat:@"%@%@", _prefix, @"_loop"];
    }
    return self;
}

-(void) drawAt:(CGPoint)pos
{
    _startFace = [[TBCharacterFace alloc] initWithStartNumFrame:0 andEndNumFrame:0 withAnimName:_startAnimationName andFilePrefix:@""];
    
    _loopFace = [[TBCharacterFace alloc] initWithStartNumFrame:_loopStartTransitionFrameNumber andEndNumFrame:_loopEndTransitionFrameNumber withAnimName:_loopAnimationName andFilePrefix:@""];
    
    [_startFace drawAt:CGPointZero];
    [_loopFace drawAt:CGPointZero];
    
    _currentFace = _startFace;
    
    [super drawAt:CGPointMake(pos.x + [self getSize].width / 2, pos.y)];
}

-(void) connectionOnRange:(BOOL)isOnRange
{
    if(_isDiscovered) return;
    
    if(isOnRange && !_isDiscovered)
    {
        _isDiscovered = true;
        
        [_startFace changeAnimation:_startAnimationName from:0 to:_startTransitionFrameNumber];
        
        [self schedule:@selector(playLoopHandler:) interval:_startTransitionFrameNumber * [_startFace delay]];
    }
}

-(void) playLoopHandler:(id)sender
{
    [self unschedule:@selector(playLoopHandler:)];
    
    [self removeChild:_currentFace.sprite cleanup:TRUE];
    
    _currentFace = _loopFace;
    
    [self addChild:_currentFace.sprite];
}

- (void)dealloc
{
    [_startFace release];
    _startFace = nil;
    
    [_loopFace release];
    _loopFace = nil;
    
    [_startAnimationName release];
    _startAnimationName = nil;
    
    [_loopAnimationName release];
    _loopAnimationName = nil;
    
    [super dealloc];
}

@end
