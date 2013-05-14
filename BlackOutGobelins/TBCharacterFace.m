
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
    int _numFrame;
    NSString *_animName;
    NSString *_prefix;
    
    CCSpriteBatchNode *_container;
}

@end

@implementation TBCharacterFace

const char *FRONT_ANIMATION_NAME = "face";
const char *BACK_ANIMATION_NAME = "dos";
const char *RIGHT_ANIMATION_NAME = "droite";
const char *LEFT_ANIMATION_NAME = "gauche";
const char *BACK_RIGHT_ANIMATION_NAME = "34dos_droite";
const char *BACK_LEFT_ANIMATION_NAME = "34dos_gauche";
const char *FRONT_RIGHT_ANIMATION_NAME = "34face_droite";
const char *FRONT_LEFT_ANIMATION_NAME = "34face_gauche";

- (id)initWithNumFrame:(int)numFrame withAnimName:(NSString*)animName andFilePrefix:(NSString*)prefix
{
    self = [super init];
    if (self) {
        _numFrame = numFrame;
        _animName = animName;
        _prefix = prefix;
        
        NSString *plistName = [NSString stringWithFormat:@"%@%@.plist", _prefix, _animName];
        NSString *pngName = [NSString stringWithFormat:@"%@%@.png", _prefix, _animName];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[TBResources getAsset:[plistName UTF8String]]];
        
        _container = [CCSpriteBatchNode batchNodeWithFile:[TBResources getAsset:[pngName UTF8String]] capacity:100];
    }
    return self;
}

-(void) drawAt:(CGPoint)pos
{
    NSString *startFrameName = [NSString stringWithFormat:@"%@_00.png", _animName];
    NSString *incrementFrameName = [NSString stringWithFormat:@"%@_%%@.png", _animName];
    
    [super buildWithImage:startFrameName at:pos andAnimateWith:incrementFrameName with:_numFrame andDelay:0.04f];
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
