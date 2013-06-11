//
//  TBFourthPlant.m
//  BlackOutGobelins
//
//  Created by tony's computer on 06/06/13.
//
//

#import "TBFourthPlant.h"

@implementation TBFourthPlant

- (id)init
{
    self = [super initWithPrefix:@"plante_fourth"];
    if (self) {
        _startTransitionFrameNumber = 14;
        _loopStartTransitionFrameNumber = 15;
        _loopEndTransitionFrameNumber = 48;
        _plantNumber = 4;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
