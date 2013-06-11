//
//  TBFirstPlant.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 31/05/13.
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
        _plantNumber = 1;
    }
    return self;
}

-(CGPoint) getPosition
{
    return CGPointMake([self position].x, [self position].y - [self getSize].height);
}

-(CGSize) getSize
{
    return CGSizeMake([super getSize].width, [super getSize].height / 2);
}

- (void)dealloc
{
    [super dealloc];
}

@end
