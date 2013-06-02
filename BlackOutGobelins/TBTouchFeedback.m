//
//  TBTouchFeedback.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 19/05/13.
//
//

#import "TBTouchFeedback.h"

@implementation TBTouchFeedback

- (id)init
{
    self = [super initWithNumFrame:19 withAnimName:@"touch_feedback" andFileName:@"touch_feedback"];
    if (self)
    {
        [self drawAt:CGPointZero];
        [self schedule:@selector(animationEnd:) interval:(0.04f * 19)];
    }
    return self;
}

+(id)touchFeedback
{
    return [[self alloc] init];
}

-(void) animationEnd:(id)sender
{
    [self unschedule:@selector(animationEnd:)];
    
    [self removeAllChildrenWithCleanup:TRUE];
    [self removeFromParentAndCleanup:TRUE];
}

- (void)dealloc
{
    [super dealloc];
}

@end
