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
#import "TBLineData.h"

@implementation TBLine
{
    CGPoint _startPoint;
    CGPoint _endPoint;
    CGPoint _medianPoint;
    
    TBTriangleConnection *_triangleConnexion;
    CCLayerColor *_layer;
    float _ratio;
    BOOL _useEffects;
    NSString *_type;
    NSString *_data;
    ccColor3B _color;
}

- (id)initFrom:(CGPoint)startPoint andTo:(CGPoint)endPoint
{
    self = [super init];
    if (self)
    {
        _startPoint = startPoint;
        _endPoint = endPoint;
        _useEffects = false;
        
        _ratio = [[TBModel getInstance] isRetinaDisplay] ? 1.0f : 0.5f;
        
        _value = 1.0f;
        _decrementer = 0.05f;
            
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideDialogueHandler:) name:@"HIDE_DIALOGUE" object:nil];
    }
    return self;

}

- (id)initFrom:(CGPoint)startPoint andTo:(CGPoint)endPoint withInteractionType:(NSString *)type andData:(NSString *)data andColor:(ccColor3B)color;
{
    self = [super init];
    if (self)
    {
        _startPoint = startPoint;
        _endPoint = endPoint;
        _type = type;
        _data = data;
        _color = color;
        _useEffects = true;
        
        _ratio = [[TBModel getInstance] isRetinaDisplay] ? 1.0f : 0.5f;
        
        _value = 1.5f;
            
        [self addEffects:color];
        [super startSchedule];
    }
    return self;
}

+ (id)lineFrom:(CGPoint)startPoint andTo:(CGPoint)endPoint
{
    return [[[self alloc] initFrom:startPoint andTo:endPoint] autorelease];
}

+ (id)lineFrom:(CGPoint)startPoint andTo:(CGPoint)endPoint withInteractionType:(NSString *)type andData:(NSString *)data andColor:(ccColor3B)color;
{
    return [[[self alloc] initFrom:startPoint andTo:endPoint withInteractionType:type andData:data andColor:color] autorelease];
}

-(void) hideDialogueHandler:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super startSchedule];
}

-(void) addEffects:(ccColor3B)color
{
    _triangleConnexion = [[TBTriangleConnection alloc] init];
    [_triangleConnexion drawAt:CGPointZero];
    
    _triangleConnexion.position = _startPoint;
    
    CCMoveTo* moveTo = [[CCMoveTo alloc] initWithDuration:_value * 2 position:_endPoint];
    
    int xDirection = _startPoint.x < _endPoint.x ? 1 : -1;
    int yDirection = _startPoint.y < _endPoint.y ? 1 : -1;
    
    float xVector = (_endPoint.x - _startPoint.x) * xDirection;
    float yVector = (_endPoint.y - _startPoint.y) * yDirection;
    
    float xDrawingRef = _startPoint.x < _endPoint.x ? _startPoint.x : _endPoint.x;
    float yDrawingRef = _startPoint.y < _endPoint.y ? _startPoint.y : _endPoint.y;
    
    int xOffset = xVector < yVector ? 90 : 0;
    int yOffset = yVector < xVector ? 90 : 0;
    
    _layer = [[TBLineData alloc] initWithType:_type andData:_data];
    [_layer setPosition:CGPointMake(xDrawingRef + xVector / 2 - _layer.contentSize.width / 2 + xOffset, yDrawingRef + yVector / 2 - _layer.contentSize.height / 2 + yOffset)];
    
    _medianPoint = CGPointMake(_layer.position.x + _layer.contentSize.width / 2, _layer.position.y + _layer.contentSize.height / 2);
   
    [self addChild:_layer];
    
    [_triangleConnexion runAction:moveTo];
    
    [self glowAt:_endPoint withScale:CGSizeMake(6.0f * _ratio, 6.0f * _ratio) withColor:ccc3(146, 236, 255) withRotation:0.0f andDuration:_value/2];
    
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
    
    if(_useEffects)
    {
        glLineWidth(0.25f * _ratio);
    
        ccDrawLine(_medianPoint, CGPointMake(_triangleConnexion.position.x - 10, _triangleConnexion.position.y + 10));
        
        if(_value < 1.0f) [_layer setOpacity:(_value * 255)];
    }
    
    if(_value < 0.3f && _useEffects)
    {
        [self glowAt:_startPoint withScale:CGSizeMake(20.0f * _ratio, 20.0f * _ratio) withColor:_color withRotation:0.0f andDuration:0.05f];
    }
}

-(void)complete
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STOP_CONNECTION" object:nil];
    
    [self removeAllChildrenWithCleanup:TRUE];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if(_triangleConnexion)
    {
        [_triangleConnexion release];
        _triangleConnexion = nil;
    }
    
    if(_layer)
    {
        [_layer release];
        _layer = nil;
    }
    
    _type = nil;
    _data = nil;
    
    [super dealloc];
}

@end
