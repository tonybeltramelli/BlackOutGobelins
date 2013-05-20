//
//  TBLine.m
//  BlackOutGobelins
//
//  Created by tony's computer on 10/05/13.
//
//

#import "TBLine.h"
#import "TBModel.h"
#import "TBTriangleConnection.h"
#import "CCDrawingPrimitives.h"

@implementation TBLine
{
    CGPoint _startPoint;
    CGPoint _endPoint;
    
    TBTriangleConnection *_triangleConnexion;
    float _ratio;
    BOOL _useEffects;
}

- (id)initFrom:(CGPoint)startPoint andTo:(CGPoint)endPoint connectionWithBot:(BOOL)boo
{
    self = [super init];
    if (self)
    {
        _startPoint = startPoint;
        _endPoint = endPoint;
        _useEffects = boo;
        
        _ratio = [[TBModel getInstance] isRetinaDisplay] ? 1.0f : 0.5f;
        
        if(_useEffects)
        {
            _value = 2.5f;
            
            [self addEffects];
            [super startSchedule];
        }else{
            _value = 1.0f;
            _decrementer = 0.05f;
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideDialogueHandler:) name:@"HIDE_DIALOGUE" object:nil];
        }
    }
    return self;
}

+ (id)lineFrom:(CGPoint)startPoint andTo:(CGPoint)endPoint connectionWithBot:(BOOL)boo
{
    return [[[self alloc] initFrom:startPoint andTo:endPoint connectionWithBot:boo] autorelease];
}

-(void) hideDialogueHandler:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super startSchedule];
}

-(void) addEffects
{
    _triangleConnexion = [[TBTriangleConnection alloc] init];
    [_triangleConnexion drawAt:CGPointZero];
    
    _triangleConnexion.position = _startPoint;
    
    CCMoveTo* moveTo = [[CCMoveTo alloc] initWithDuration:_value * 2 position:_endPoint];
    
    [_triangleConnexion runAction:moveTo];
    
    [self glowAt:_endPoint withScale:CGSizeMake(6.0f * _ratio, 6.0f * _ratio) withColor:ccc3(146,236,255) withRotation:0.0f andDuration:_value/2];
    
    [self addChild:_triangleConnexion];
}

-(void) glowAt:(CGPoint)position withScale:(CGSize)size withColor:(ccColor3B)color withRotation:(float)rotation andDuration:(float)duration
{
    CCSprite *glowSprite = [CCSprite spriteWithFile:@"fire.png"];
    [glowSprite setColor:color];
    [glowSprite setPosition:position];
    [glowSprite setRotation:rotation];
    [glowSprite setBlendFunc:(ccBlendFunc) {GL_ONE, GL_ONE}];
    
    [glowSprite runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCScaleTo actionWithDuration:0.9f scaleX:size.width scaleY:size.height], [CCScaleTo actionWithDuration:duration scaleX:size.width * 0.75f scaleY:size.height * 0.75f], nil]]];
    
    [glowSprite runAction: [CCRepeatForever actionWithAction: [CCSequence actions:[CCFadeTo actionWithDuration:0.9f opacity:150], [CCFadeTo actionWithDuration:duration opacity:255], nil]]];
    
    [self addChild: glowSprite];
}

-(void)draw
{
    glLineWidth(5.0f * _ratio);
    
    ccDrawColor4F(_value, _value, _value, _value);
    
    ccDrawLine(_startPoint, _endPoint);
    
    if(_value < 0.3f && _useEffects)
    {
        [self glowAt:_startPoint withScale:CGSizeMake(20.0f * _ratio, 20.0f * _ratio) withColor:ccc3(146,236,255) withRotation:0.0f andDuration:0.05f];
    }
}

-(void)complete
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STOP_CONNECTION" object:nil];
    
    [self removeAllChildrenWithCleanup:TRUE];
}

@end
