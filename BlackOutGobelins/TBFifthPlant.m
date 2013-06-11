//
//  TBFifthPlant.m
//  BlackOutGobelins
//
//  Created by tony's computer on 06/06/13.
//
//

#import "TBFifthPlant.h"

@implementation TBFifthPlant

- (id)init
{
    self = [super initWithPrefix:@"plante_fifth"];
    if (self) {
        _startTransitionFrameNumber = 12;
        _loopStartTransitionFrameNumber = 13;
        _loopEndTransitionFrameNumber = 39;
        _plantNumber = 5;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
