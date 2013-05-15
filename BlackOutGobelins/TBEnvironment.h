//
//  TBEnvironment.h
//  BlackOut
//
//  Created by Tony BELTRAMELLI on 22/01/13.
//
//

#import "CCSprite.h"
#import "TBMap.h"

@interface TBEnvironment : CCSprite

- (CGPoint)getStartPositionFromMeta;
- (NSMutableArray *)getBotsStartPositions:(int)botNumber;
- (NSMutableArray *)getCharactersPositions:(int)charactersNumber;
- (NSMutableArray *)getObstaclesPositions;
- (BOOL)isCollisionAt:(CGPoint)position;
- (BOOL)isObstacleAt:(CGPoint)position;
- (void)removeMetaTileAt:(CGPoint)position;

@end
