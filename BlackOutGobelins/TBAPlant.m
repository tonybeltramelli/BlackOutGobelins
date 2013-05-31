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
}

- (id)initWithPrefix:(NSString *)prefix
{
    self = [super init];
    if (self) {
        _prefix = prefix;
        
        _startAnimationName = @"_debut";
        _loopAnimationName = @"_loop";
    }
    return self;
}

-(void) drawAt:(CGPoint)pos
{
    [self setPosition:pos];
    
    _startFace = [[TBCharacterFace alloc] initWithStartNumFrame:0 andEndNumFrame:0 withAnimName:[NSString stringWithFormat:@"%@%@", _prefix, _startAnimationName] andFilePrefix:@""];
    
    _loopFace = [[TBCharacterFace alloc] initWithStartNumFrame:_loopStartTransitionFrameNumber andEndNumFrame:_loopEndTransitionFrameNumber withAnimName:[NSString stringWithFormat:@"%@%@", _prefix, _loopAnimationName] andFilePrefix:@""];
    
    [_startFace drawAt:CGPointZero];
    [_loopFace drawAt:CGPointZero];
    
    [self addChild:_startFace.sprite];
}

-(void) connectionOnRange:(BOOL)isOnRange
{
}

-(CGPoint) getPosition
{
    return [self position];
}

-(CGSize) getSize
{
    return _startFace.getSize;
}

@end
