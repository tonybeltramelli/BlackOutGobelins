//
//  TBConnectionAsset.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 18/05/13.
//
//

#import "TBConnectionAsset.h"

@implementation TBConnectionAsset

- (id)init
{
    self = [super initWithFilePrefix:@"connexion" andStartTransitionFirstFrame:0 andStartTransitionLastFrame:49];
    if (self)
    {
        _middleTransitionFirstFrameNumber = 0;
        _middleTransitionLastFrameNumber = 49;
        
        _endTransitionFirstFrameNumber = 0;
        _endTransitionLastFrameNumber = 49;
    }
    return self;
}

@end
