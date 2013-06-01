//
//  TBSequenceFace.h
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 18/05/13.
//
//

#import "CCLayer.h"

@interface TBSequenceFace : CCLayer
{
    NSString *_startTransitionName;
    NSString *_endTransitionName;
    NSString *_middleTransitionName;
    
    int _startTransitionFirstFrameNumber;
    int _startTransitionLastFrameNumber;
    
    int _endTransitionFirstFrameNumber;
    int _endTransitionLastFrameNumber;
    
    int _middleTransitionFirstFrameNumber;
    int _middleTransitionLastFrameNumber;
}

- (id)initWithFilePrefix:(NSString *)prefix andStartTransitionFirstFrame:(int)startNumber andStartTransitionLastFrame:(int)endNumber;

-(void) drawAt:(CGPoint)pos;
-(void) stopConnection;

- (CGSize)getSize;

@end
