
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
    
    CCSpriteBatchNode *_container;
}

@end

@implementation TBCharacterFace

- (id)initWithStartNumFrame:(int)startNumFrame andEndNumFrame:(int)endNumFrame withAnimName:(NSString*)animName andFilePrefix:(NSString*)prefix
{
    self = [super init];
    if (self)
    {
        _numStartFrame = startNumFrame;
        _numEndFrame = endNumFrame;
        _animName = animName;
        _prefix = prefix;
        
        NSString *plistName = [NSString stringWithFormat:@"%@%@.plist", _prefix, _animName];
        NSString *pngName = [NSString stringWithFormat:@"%@%@.png", _prefix, _animName];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[TBResources getAsset:[plistName UTF8String]]];
        
        _container = [CCSpriteBatchNode batchNodeWithFile:[TBResources getAsset:[pngName UTF8String]] capacity:100];
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
    
    [super buildWithImage:startFrameName at:pos andAnimateWith:incrementFrameName startAt:_numStartFrame endAt:_numEndFrame andDelay:0.04f];
}

-(CGPoint) getVolumicBoundariesFromPositionTarget:(CGPoint)position
{
    CGPoint target = CGPointMake([self getX] + position.x, [self getY] + position.y);
    
    int x = [self getX] > target.x ? - 10 : 10;
    int y = [self getY] < target.y ? 0 : -21;
    
    return CGPointMake(x, y);
}

- (void)dealloc
{
    [super dealloc];
}

@end
