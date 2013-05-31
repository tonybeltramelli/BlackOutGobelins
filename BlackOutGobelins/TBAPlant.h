//
//  TBAPlant.h
//  BlackOutGobelins
//
//  Created by tony's computer on 31/05/13.
//
//

#import "CCLayer.h"
#import "TBConnectableElement.h"

@interface TBAPlant : CCLayer <TBConnectableElement>
{
    int _startTransitionFrameNumber;
    int _loopStartTransitionFrameNumber;
    int _loopEndTransitionFrameNumber;
}

- (id)initWithPrefix:(NSString *)prefix;
-(void) drawAt:(CGPoint)pos;

@end
