//
//  TBLine.m
//  BlackOutGobelins
//
//  Created by tony's computer on 10/05/13.
//
//

#import "TBLine.h"
#import "CCDrawingPrimitives.h"

@implementation TBLine
{
    CGPoint _startPoint;
    CGPoint _endPoint;
}

- (id)initFrom:(CGPoint)startPoint andTo:(CGPoint)endPoint
{
    self = [super init];
    if (self) {
        _startPoint = startPoint;
        _endPoint = endPoint;
        
        _decrementer = 1.5f;
    }
    return self;
}

-(void)draw
{
    glLineWidth(5.0f);
    
    ccDrawColor4F(_decrementer, _decrementer, _decrementer, _decrementer);
    
    ccDrawLine(_startPoint, _endPoint);
}

@end
