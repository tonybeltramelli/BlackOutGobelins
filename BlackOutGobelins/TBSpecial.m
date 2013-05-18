//
//  TBSpecial.m
//  BlackOutGobelins
//
//  Created by tony's computer on 10/05/13.
//
//

#import "TBSpecial.h"

@implementation TBSpecial

- (id)init
{
    self = [super init];
    if (self) {
        [self scheduleUpdate];
    }
    return self;
}

-(void) update:(ccTime)delta
{
    _decrementer -= 0.01f;
    
    if(_decrementer <= 0.0f)
    {
        [self complete];
        [[self parent] removeChild:self cleanup:TRUE];
    }
}

-(void) complete {}

@end
