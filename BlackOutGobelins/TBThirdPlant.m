//
//  TBThirdPlant.m
//  BlackOutGobelins
//
//  Created by tony's computer on 06/06/13.
//
//

#import "TBThirdPlant.h"

@implementation TBThirdPlant

- (id)init
{
    self = [super initWithPrefix:@"plante_third"];
    if (self) {
        _startTransitionFrameNumber = 20;
        _loopStartTransitionFrameNumber = 21;
        _loopEndTransitionFrameNumber = 44;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
