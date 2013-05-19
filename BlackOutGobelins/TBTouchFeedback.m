//
//  TBTouchFeedback.m
//  BlackOutGobelins
//
//  Created by tony's computer on 19/05/13.
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
    return [[[self alloc] init] retain];
}

-(void) animationEnd:(id)sender
{
    [self unschedule:@selector(animationEnd:)];
    
    [[self parent] removeChild:self cleanup:TRUE];
}

@end
