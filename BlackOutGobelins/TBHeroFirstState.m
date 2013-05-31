//
//  TBHeroFirstState.m
//  BlackOut
//
//  Created by tony's computer on 06/02/13.
//
//

#import "TBHeroFirstState.h"

@implementation TBHeroFirstState

const int HERO_RANGE = 100;

- (id)init
{    
    self = [super initWithPrefix:@"hero_first_" andPauseTransitionFirstFrame:0 andPauseTransitionLastFrame:36];
    if (self)
    {
    }
    return self;
}

-(BOOL)isOnHeroRange:(id<TBConnectableElement>)element
{
    float minusX = [self position].x - HERO_RANGE;
    float maxX = [self position].x + HERO_RANGE;
    
    float minusY = [self position].y - HERO_RANGE;
    float maxY = [self position].y + HERO_RANGE;
    
    if((minusX < [element getPosition].x + [element getSize].width/2) && (maxX > [element getPosition].x - [element getSize].width/2) &&
       (minusY < [element getPosition].y + [element getSize].height/2) && (maxY > [element getPosition].y - [element getSize].height/2))
    {
        return true;
    }
    
    return false;
}

-(void)frontAnimation
{
    _startTransitionFirstFrameNumber = 0;
    _startTransitionLastFrameNumber = 12;
    
    _middleTransitionFirstFrameNumber = 12;
    _middleTransitionLastFrameNumber = 20;
    
    _endTransitionFirstFrameNumber = 31;
    _endTransitionLastFrameNumber = 41;
    
    [super startToWalk];
}

-(void) backAnimation
{
    _startTransitionFirstFrameNumber = 0;
    _startTransitionLastFrameNumber = 12;
    
    _middleTransitionFirstFrameNumber = 12;
    _middleTransitionLastFrameNumber = 20;
    
    _endTransitionFirstFrameNumber = 31;
    _endTransitionLastFrameNumber = 41;
    
    [super startToWalk];
}

-(void) rightAnimation
{
    _startTransitionFirstFrameNumber = 0;
    _startTransitionLastFrameNumber = 11;
    
    _middleTransitionFirstFrameNumber = 12;
    _middleTransitionLastFrameNumber = 20;
    
    _endTransitionFirstFrameNumber = 32;
    _endTransitionLastFrameNumber = 41;
    
    [super startToWalk];
}

-(void) leftAnimation
{
    _startTransitionFirstFrameNumber = 0;
    _startTransitionLastFrameNumber = 11;

    _middleTransitionFirstFrameNumber = 12;
    _middleTransitionLastFrameNumber = 31;
    
    _endTransitionFirstFrameNumber = 32;
    _endTransitionLastFrameNumber = 41;
    
    [super startToWalk];
}

@end
