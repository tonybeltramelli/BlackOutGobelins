//
//  TBCharacterFace.h
//  BlackOut
//
//  Created by tony's computer on 07/02/13.
//
//

#import "TBSimpleItem.h"

@interface TBCharacterFace : TBSimpleItem

@property(assign, nonatomic) float delay;

- (id)initWithNumFrame:(int)numFrame withAnimName:(NSString*)animName andFilePrefix:(NSString*)prefix;
- (id)initWithStartNumFrame:(int)startNumFrame andEndNumFrame:(int)endNumFrame withAnimName:(NSString*)animName andFilePrefix:(NSString*)prefix;
- (id)initWithStartNumFrame:(int)startNumFrame andEndNumFrame:(int)endNumFrame withAnimName:(NSString*)animName andFileName:(NSString *)fileName andFilePrefix:(NSString*)prefix;

-(CGPoint) getVolumicBoundariesFromPositionTarget:(CGPoint)position;
-(void) changeAnimation:(NSString *)animName from:(int)startNumFrame to:(int)endNumFrame;

@end
