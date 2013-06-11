//
//  TBSeventhPlant.m
//  BlackOutGobelins
//
//  Created by tony's computer on 06/06/13.
//
//

#import "TBSeventhPlant.h"

@implementation TBSeventhPlant

- (id)init
{
    self = [super initWithPrefix:@"plante_seventh"];
    if (self) {
        _startTransitionFrameNumber = 18;
        _loopStartTransitionFrameNumber = 19;
        _loopEndTransitionFrameNumber = 38;
        _plantNumber = 7;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
