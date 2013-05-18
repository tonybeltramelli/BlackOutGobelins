//
//  TBGameController.h
//  BlackOutGobelins
//
//  Created by tony's computer on 01/05/13.
//
//

#import <Foundation/Foundation.h>

#import "TBHeroFirstState.h"

@interface TBGameController : NSObject

- (id)initInLayer:(CCLayer *)layer withHero:(TBHeroFirstState *)hero;
- (void)useJoystick:(BOOL)useIt;
- (void)useTouch:(BOOL)useIt;
- (CGPoint)getTargetPosition;
- (BOOL)doNeedToIgnoreTouchAction;

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
