//
//  TBSecondPlant.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 31/05/13.
//
//

#import "TBSecondPlant.h"

@implementation TBSecondPlant

- (id)init
{
    self = [super initWithPrefix:@"plante_second"];
    if (self) {
        _startTransitionFrameNumber = 50;
        _loopStartTransitionFrameNumber = 50;
        _loopEndTransitionFrameNumber = 84;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
