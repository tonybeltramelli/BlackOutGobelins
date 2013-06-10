//
//  TBBotThirdState.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 28/05/13.
//
//

#import "TBBotThirdState.h"
#import "TBModel.h"

@implementation TBBotThirdState
{
    CCSprite *_glowSprite;
    BOOL _isOn;
    
    int _incrementValue;
    int _limit;
}

- (id)init
{
    self = [super initWithPrefix:@"bot_third_" andPauseTransitionFirstFrame:0 andPauseTransitionLastFrame:24];
    if (self)
    {
        _connectionStartFirstFrameNumber = 0;
        _connectionStartLastFrameNumber = 24;
        
        _connectionMiddleFirstFrameNumber = 0;
        _connectionMiddleLastFrameNumber = 23;
        
        _disconnectionStartFirstFrameNumber = 0;
        _disconnectionStartLastFrameNumber = 19;
        
        _disconnectionMiddleFirstFrameNumber = 0;
        _disconnectionMiddleLastFrameNumber = 24;
        
        _color = ccc3(116, 224, 255); //0x74e0ff
        
        _gravityCenter = CGPointMake(4, -10);
        
        _limit = 500;
        _isOn = false;
        
        _glowSprite = [CCSprite spriteWithFile:@"fire.png"];
        [_glowSprite setColor:_color];
        [_glowSprite setPosition:[self position]];
        [_glowSprite setBlendFunc:(ccBlendFunc) {GL_ONE, GL_ONE}];
        
        float ratio = [[TBModel getInstance] isRetinaDisplay] ? 1.0f : 0.5f;
        
        CGSize size = CGSizeMake(10.0f * ratio, 12.0f * ratio);
        
        [_glowSprite runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCScaleTo actionWithDuration:0.9f scaleX:size.width scaleY:size.height], [CCScaleTo actionWithDuration:0.5f scaleX:size.width * 0.9f scaleY:size.height * 0.9f], nil]]];
        
        [self addChild:_glowSprite z:1];
        [_glowSprite setPosition:CGPointMake(9.0f, 10.0f)];
    }
    return self;
}

-(void) update
{
    if(_isDeconnected || _isConnecting) return;
    
    _incrementValue ++;
    
    if(_incrementValue == _limit)
    {
        _incrementValue = 0;
        
        _isOn = !_isOn;
        
        _limit = _isOn ? 100 : 500;
        
        [_glowSprite runAction:[CCFadeTo actionWithDuration:0.6f opacity:_isOn ? 0 : 255]];
    }
}

-(void) handleConnection:(BOOL)toConnect
{    
    [super handleConnection:toConnect];
    
    if(toConnect)
    {
        _isOn = false;
        [_glowSprite runAction:[CCFadeTo actionWithDuration:0.3f opacity:0]];
    }
}

-(BOOL) isConnectable
{
    if(!_isOn) return false;
    
    return [super isConnectable];
}

- (void)dealloc
{
    _glowSprite = nil;
    
    [super dealloc];
}

@end
