
//
//  TBCharacterFace.m
//  BlackOut
//
//  Created by tony's computer on 07/02/13.
//
//

#import "TBCharacterFace.h"
#import "TBResources.h"

@interface TBCharacterFace()
{
    int _numStartFrame;
    int _numEndFrame;
    
    NSString *_animName;
    NSString *_prefix;
    NSString *_fileName;
}

@end

@implementation TBCharacterFace

@synthesize delay = _delay;

- (id)initWithStartNumFrame:(int)startNumFrame andEndNumFrame:(int)endNumFrame withAnimName:(NSString*)animName andFileName:(NSString *)fileName andFilePrefix:(NSString*)prefix
{
    self = [super init];
    if (self)
    { 
        _numStartFrame = startNumFrame;
        _numEndFrame = endNumFrame;
        _animName = [fileName isEqualToString:animName] || [fileName isEqualToString:@""]? animName : [NSString stringWithFormat:@"%@_%@", animName, fileName];
        _fileName = fileName;
        _prefix = prefix;
        
        _delay = 0.04f;
        
        NSString *plistName = [NSString stringWithFormat:@"%@%@.plist", _prefix, fileName];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[TBResources getAsset:[plistName UTF8String]]];
    }
    return self;
}

- (id)initWithStartNumFrame:(int)startNumFrame andEndNumFrame:(int)endNumFrame withAnimName:(NSString*)animName andFilePrefix:(NSString*)prefix
{
    self = [self initWithStartNumFrame:startNumFrame andEndNumFrame:endNumFrame withAnimName:animName andFileName:animName andFilePrefix:prefix];
    if (self) {
    }
    return self;
}

- (id)initWithNumFrame:(int)numFrame withAnimName:(NSString*)animName andFilePrefix:(NSString*)prefix
{
    self = [self initWithStartNumFrame:0 andEndNumFrame:numFrame withAnimName:animName andFilePrefix:prefix];
    if (self) {
    }
    return self;
}

-(void) drawAt:(CGPoint)pos
{
    NSString *number = _numStartFrame < 10 ? [NSString stringWithFormat:@"0%d", _numStartFrame] : [NSString stringWithFormat:@"%d", _numStartFrame];
   
    NSString *startFrameName = [NSString stringWithFormat:@"%@_%@.png", _animName, number];
    NSString *incrementFrameName = [NSString stringWithFormat:@"%@_%%@.png", _animName];
    
    [super buildWithImage:startFrameName at:pos andAnimateWith:incrementFrameName startAt:_numStartFrame endAt:_numEndFrame andDelay:_delay];
}

-(CGPoint) getVolumicBoundariesFromPositionTarget:(CGPoint)position
{
    CGPoint target = CGPointMake([self getX] + position.x, [self getY] + position.y);
    
    int x = [self getX] > target.x ? - 10 : 10;
    int y = [self getY] < target.y ? 0 : -21;
    
    return CGPointMake(x, y);
}

-(void) changeAnimation:(NSString *)animName from:(int)startNumFrame to:(int)endNumFrame
{
    _animName = [_fileName isEqualToString:animName] || [_fileName isEqualToString:@""] ? animName : [NSString stringWithFormat:@"%@_%@", animName, _fileName];
    
    NSString *incrementFrameName = [NSString stringWithFormat:@"%@_%%@.png", _animName];
    
    [super setAnimation:incrementFrameName startAt:startNumFrame andEnd:endNumFrame andDelay:_delay];
}

-(void) changeAnimationHard:(NSString *)animName from:(int)startNumFrame to:(int)endNumFrame
{
    _animName = animName;
    
    NSString *incrementFrameName = [NSString stringWithFormat:@"%@_%%@.png", _animName];
    
    [super setAnimation:incrementFrameName startAt:startNumFrame andEnd:endNumFrame andDelay:_delay];
}

- (void)dealloc
{
    _animName = nil;
    _prefix = nil;
    _fileName = nil;
    
    [super dealloc];
}

@end
