//
//  TBJoystick.h
//  BlackOut
//
//  Created by Tony BELTRAMELLI on 12/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

@interface TBJoystick : CCLayer

@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint values;
@property (assign, nonatomic) BOOL isCenterWithTouchEnd;

- (id)initWithIsCenterWithTouchEnd:(BOOL)isCenterWithTouchEnd;
- (void)setLocation:(CGPoint)location;
- (void)reset;
- (BOOL)isPressed;

@end
