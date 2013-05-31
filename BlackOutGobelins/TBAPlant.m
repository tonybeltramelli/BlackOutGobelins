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
    NSString *_prefix;
    
    BOOL _isDiscovered;
}

- (id)initWithPrefix:(NSString *)prefix
{
    self = [super init];
    if (self) {
        _prefix = prefix;
        
        _startAnimationName = [[NSString alloc] initWithFormat:@"%@%@", _prefix, @"_debut"];
        _loopAnimationName = [[NSString alloc] initWithFormat:@"%@%@", _prefix, @"_loop"];
        
        _isDiscovered = false;
    }
    return self;
}

-(void) drawAt:(CGPoint)pos
{
    [self setPosition:pos];
    
    _startFace = [[TBCharacterFace alloc] initWithStartNumFrame:0 andEndNumFrame:0 withAnimName:_startAnimationName andFilePrefix:@""];
    
    _loopFace = [[TBCharacterFace alloc] initWithStartNumFrame:_loopStartTransitionFrameNumber andEndNumFrame:_loopEndTransitionFrameNumber withAnimName:_loopAnimationName andFilePrefix:@""];
    
    [_startFace drawAt:CGPointZero];
    [_loopFace drawAt:CGPointZero];
    
    [self addChild:_startFace.sprite];
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
    
    [self removeChild:_startFace.sprite cleanup:TRUE];
    
    [self addChild:_loopFace.sprite];
}

-(CGPoint) getPosition
{
    return [self position];
}

-(CGSize) getSize
{
    return _isDiscovered ? _loopFace.getSize : _startFace.getSize;
}

@end
