//
//  TBSixthPlant.m
//  BlackOutGobelins
//
//  Created by tony's computer on 06/06/13.
//
//

#import "TBSixthPlant.h"

@implementation TBSixthPlant

- (id)init
{
    self = [super initWithPrefix:@"plante_sixth"];
    if (self) {
        _startTransitionFrameNumber = 17;
        _loopStartTransitionFrameNumber = 18;
        _loopEndTransitionFrameNumber = 47;
        _plantNumber = 6;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
