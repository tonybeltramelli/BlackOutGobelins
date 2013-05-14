//
//  TBMapElement.h
//  BlackOut
//
//  Created by tony's computer on 19/02/13.
//
//

#import "CCLayer.h"

@interface TBMapElement : CCLayer

- (id)initWithNumFrame:(int)numFrame withAnimName:(NSString*)animName andFileName:(NSString*)fileName;
- (void)drawAt:(CGPoint)pos;

- (CGSize)getSize;
- (CGPoint)getPosition;

@end
