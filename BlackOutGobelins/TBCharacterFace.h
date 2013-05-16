//
//  TBCharacterFace.h
//  BlackOut
//
//  Created by tony's computer on 07/02/13.
//
//

#import "TBSimpleItem.h"

@interface TBCharacterFace : TBSimpleItem

- (id)initWithNumFrame:(int)numFrame withAnimName:(NSString*)animName andFilePrefix:(NSString*)prefix;
- (id)initWithStartNumFrame:(int)startNumFrame andEndNumFrame:(int)endNumFrame withAnimName:(NSString*)animName andFilePrefix:(NSString*)prefix;

-(CGPoint) getVolumicBoundariesFromPositionTarget:(CGPoint)position;

@end
