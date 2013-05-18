//
//  TBMapElement.m
//  BlackOut
//
//  Created by tony's computer on 19/02/13.
//
//

#import "TBMapElement.h"
#import "TBSimpleItem.h"
#import "TBResources.h"

@implementation TBMapElement
{
    int _numFrame;
    NSString *_animName;
    NSString *_fileName;
    
    TBSimpleItem *_simpleItem;
}

- (id)initWithNumFrame:(int)numFrame withAnimName:(NSString*)animName andFileName:(NSString*)fileName
{
    self = [super init];
    if (self) {
        _numFrame = numFrame;
        _animName = animName;
        _fileName = fileName;
        
        NSString *plistName = [NSString stringWithFormat:@"%@.plist", _fileName];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[TBResources getAsset:[plistName UTF8String]]];
        
        _simpleItem = [[TBSimpleItem alloc] init];
    }
    return self;
}

-(void) drawAt:(CGPoint)pos
{
    NSString *startFrameName = [NSString stringWithFormat:@"%@_00.png", _animName];
    NSString *incrementFrameName = [NSString stringWithFormat:@"%@_%%@.png", _animName];
    
    [_simpleItem buildWithImage:startFrameName at:pos andAnimateWith:incrementFrameName with:_numFrame andDelay:0.04f];
    [self addChild:_simpleItem.sprite];
}

- (CGSize)getSize
{
    return [_simpleItem getSize];
}

- (CGPoint)getPosition
{
    return [_simpleItem getPosition];
}

- (void)dealloc
{
    [_simpleItem release];
    _simpleItem = nil;
    
    [super dealloc];
}

@end
