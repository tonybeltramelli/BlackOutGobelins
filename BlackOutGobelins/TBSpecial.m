//
//  TBSpecial.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 10/05/13.
//
//

#import "TBSpecial.h"

@implementation TBSpecial

- (id)init
{
    self = [super init];
    if (self) {
        _decrementer = 0.01f;
    }
    return self;
}

-(void)startSchedule
{
    [self scheduleUpdate];
}

-(void) update:(ccTime)delta
{
    _value -= _decrementer;
    
    if(_value <= 0.0f)
    {
        [[self parent] removeChild:self cleanup:FALSE];
        [self complete];
    }
}

-(void) complete {}

@end
