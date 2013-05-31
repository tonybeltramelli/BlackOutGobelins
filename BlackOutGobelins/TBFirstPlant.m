//
//  TBFirstPlant.m
//  BlackOutGobelins
//
//  Created by tony's computer on 31/05/13.
//
//

#import "TBFirstPlant.h"

@implementation TBFirstPlant

- (id)init
{
    self = [super initWithPrefix:@"plante_first"];
    if (self) {
        _startTransitionFrameNumber = 29;
        _loopStartTransitionFrameNumber = 30;
        _loopEndTransitionFrameNumber = 75;
    }
    return self;
}

@end
