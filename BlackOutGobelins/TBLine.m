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
    
}

- (id)initFrom:(CGPoint)startPoint andTo:(CGPoint)endPoint
{
    self = [super init];
    if (self) {
        _startPoint = startPoint;
        _endPoint = endPoint;
        
        _decrementer = 1.5f;
        
        _triangleConnexion = [[TBTriangleConnection alloc] init];
        [_triangleConnexion drawAt:CGPointZero];
        
        _triangleConnexion.position = _startPoint;
        
        CCMoveTo* moveTo = [[CCMoveTo alloc] initWithDuration:_decrementer*2 position:_endPoint];
        
        [_triangleConnexion runAction:moveTo];
        
        [self addChild:_triangleConnexion];
    }
    return self;
}

-(void)draw
{
    float ratio = [[TBModel getInstance] isRetinaDisplay] ? 1.0f : 0.5f;
    
    glLineWidth(5.0f * ratio);
    
    ccDrawColor4F(_decrementer, _decrementer, _decrementer, _decrementer);
    
    ccDrawLine(_startPoint, _endPoint);
}

-(void)complete
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STOP_CONNECTION" object:nil];
    
    [self removeAllChildrenWithCleanup:TRUE];
}

@end
