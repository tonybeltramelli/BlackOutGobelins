//
//  CCProgressBar.h
//  BlackOutGobelins
//
//  Created by macbook on 10/08/11.
//  Modified by Tony BELTRAMELLI on 19/05/13.
//

#import <Foundation/Foundation.h>
#import "CCNode.h"
#import "CCProtocols.h"


@class CCSpriteScale9;

@interface CCProgressBar : CCNode

+(id)progressBarWithBgSprite:(CCSpriteScale9*)b andFgSprite:(CCSpriteScale9*)f andSize:(CGSize)s andMargin:(CGSize)m;
-(id)initWithBgSprite:(CCSpriteScale9*)b andFgSprite:(CCSpriteScale9*)f andSize:(CGSize)s andMargin:(CGSize)m;

-(void)setProgress:(float)p;
-(void)animateProgress:(float)p;
-(void)startAnimation;
-(void)stopAnimation;
-(void)setOpacity:(GLubyte)opacity;

@end
