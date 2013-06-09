
//
//  TBFingerTutorial.m
//  BlackOutGobelins
//
//  Created by tony's computer on 08/06/13.
//
//

#import "TBFingerTutorial.h"
#import "TBResources.h"
#import "TBTouchFeedback.h"
#import "TBParticle.h"

@implementation TBFingerTutorial
{
    CGSize _size;
    CCSprite *_finger;
    
    CGPoint _startPositionParticle;
    CGPoint _endPositionParticle;
    float _duration;
    float _incrementer;
    int _step;
}

- (id)initWithSize:(CGSize)size andCharacterPosition:(CGPoint)charPos
{
    self = [super init];
    if (self)
    {
        _size = size;
        
        _duration = 0.6f;
        _step = 20;
        
        _finger = [[CCSprite alloc] initWithFile:[TBResources getAsset:"finger.png"]];
        [_finger setPosition:CGPointMake(_size.width / 2, -_finger.contentSize.height)];
        [self addChild:_finger];
        
        _startPositionParticle = CGPointMake(charPos.x + _size.width / 2, charPos.y + _size.height / 2 - _finger.contentSize.height / 2);
        _endPositionParticle = CGPointMake(_size.width / 2, _size.height / 2 - _finger.contentSize.height / 2);
        
        id action1 = [CCMoveTo actionWithDuration:1.2 position: CGPointMake((_size.width / 4) * 3, _size.height / 2)];
        id functionCall1 = [CCCallFunc actionWithTarget:self selector:@selector(addTouchFeedBack1:)];
        id delay1 = [CCDelayTime actionWithDuration:0.6];
        id action2 = [CCMoveTo actionWithDuration:0.6 position: CGPointMake((_size.width / 4) * 3, _size.height / 5)];
        id functionCall2 = [CCCallFunc actionWithTarget:self selector:@selector(addTouchFeedBack2:)];
        id delay2 = [CCDelayTime actionWithDuration:2];
        id action3 = [CCMoveTo actionWithDuration:1.2 position: _startPositionParticle];
        id functionCall3 = [CCCallFunc actionWithTarget:self selector:@selector(addParticle1:)];
        id action4 = [CCMoveTo actionWithDuration:_duration position: _endPositionParticle];
        id functionCall4 = [CCCallFunc actionWithTarget:self selector:@selector(addParticle2:)];
        id fadeOut = [CCFadeOut actionWithDuration:0.6];
        id delay = [CCDelayTime actionWithDuration:1.2];
        id functionCall5 = [CCCallFunc actionWithTarget:self selector:@selector(hidden:)];
        
        [_finger runAction: [CCSequence actions:action1, functionCall1, delay1, action2, functionCall2, delay2, action3, functionCall3, action4, functionCall4, fadeOut, delay, functionCall5, nil]];
    }
    return self;
}

-(void)addTouchFeedBack1:(id)sender
{
    [self addTouchFeedBackAt:CGPointMake((_size.width / 4) * 3, (_size.height / 2) + _finger.contentSize.height / 2)];
}

-(void)addTouchFeedBack2:(id)sender
{
    [self addTouchFeedBackAt:CGPointMake((_size.width / 4) * 3, (_size.height / 5) + _finger.contentSize.height / 2)];
}

-(void)addTouchFeedBackAt:(CGPoint)position
{
    TBTouchFeedback *touchFeedBack = [TBTouchFeedback touchFeedback];
    [touchFeedBack setPosition:position];
    [self addChild:touchFeedBack z:1];
}

-(void) particleHandler:(id)sender
{
    CGPoint particlePosition = CGPointMake(_startPositionParticle.x + (((_endPositionParticle.x - _startPositionParticle.x) / _step) * _incrementer), (_startPositionParticle.y + (((_endPositionParticle.y - _startPositionParticle.y) / _step) * _incrementer) + _finger.contentSize.height/2));
    
    [self addParticleAt:particlePosition];
    
    _incrementer ++;
}

-(void)addParticle1:(id)sender
{
    _incrementer = 0.0f;
    
    float stepDuration = _duration / _step;
    
    [self schedule:@selector(particleHandler:) interval:stepDuration];
}

-(void)addParticle2:(id)sender
{
    [self unschedule:@selector(particleHandler:)];
}

-(void)addParticleAt:(CGPoint)position
{
    TBParticle *particle = [[[TBParticle alloc] initAt:position with:0xffffff] autorelease];
    [self addChild:particle];
}

-(void)hidden:(id)sender
{
    [self removeAllChildrenWithCleanup:TRUE];
    [self removeFromParentAndCleanup:TRUE];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TUTORIAL_OVER" object:self];
}

- (void)dealloc
{
    [_finger release];
    _finger = nil;
    
    [super dealloc];
}

@end
