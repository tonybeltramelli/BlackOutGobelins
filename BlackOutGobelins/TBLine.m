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
}

- (id)initFrom:(CGPoint)startPoint andTo:(CGPoint)endPoint
{
    self = [super init];
    if (self)
    {
        _startPoint = startPoint;
        _endPoint = endPoint;
        
        _decrementer = 2.5f;
        _ratio = [[TBModel getInstance] isRetinaDisplay] ? 1.0f : 0.5f;
        
        _triangleConnexion = [[TBTriangleConnection alloc] init];
        [_triangleConnexion drawAt:CGPointZero];
        
        _triangleConnexion.position = _startPoint;
        
        CCMoveTo* moveTo = [[CCMoveTo alloc] initWithDuration:_decrementer * 2 position:_endPoint];
        
        [_triangleConnexion runAction:moveTo];
        
        [self glowAt:_endPoint withScale:CGSizeMake(6.0f * _ratio, 6.0f * _ratio) withColor:ccc3(146,236,255) withRotation:0.0f andDuration:_decrementer/2];
        
        [self addChild:_triangleConnexion];
    }
    return self;
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
    
    ccDrawColor4F(_decrementer, _decrementer, _decrementer, _decrementer);
    
    ccDrawLine(_startPoint, _endPoint);
    
    if(_decrementer < 0.3f)
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
