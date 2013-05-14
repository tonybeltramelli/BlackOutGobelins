//
//  TBCharacterFace.h
//  BlackOut
//
//  Created by tony's computer on 07/02/13.
//
//

#import "TBSimpleItem.h"

@interface TBCharacterFace : TBSimpleItem

extern const char *FRONT_ANIMATION_NAME;
extern const char *BACK_ANIMATION_NAME;
extern const char *RIGHT_ANIMATION_NAME;
extern const char *LEFT_ANIMATION_NAME;
extern const char *BACK_RIGHT_ANIMATION_NAME;
extern const char *BACK_LEFT_ANIMATION_NAME;
extern const char *FRONT_RIGHT_ANIMATION_NAME;
extern const char *FRONT_LEFT_ANIMATION_NAME;

- (id)initWithNumFrame:(int)numFrame withAnimName:(NSString*)animName andFilePrefix:(NSString*)prefix;
-(CGPoint) getVolumicBoundariesFromPositionTarget:(CGPoint)position;

@end
